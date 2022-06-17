module StripeMock
  module RequestHandlers
    module CreditNotes
      def CreditNotes.included(klass)
        klass.add_handler 'post /v1/credit_notes',           :new_credit_note
        klass.add_handler 'get /v1/credit_notes/(.*)',       :get_credit_note
        klass.add_handler 'get /v1/credit_notes',            :list_credit_notes
        klass.add_handler 'post /v1/credit_notes/(.*)/void', :void_credit_note
        klass.add_handler 'post /v1/credit_notes/(.*)',      :update_credit_note
      end

      def new_credit_note(route, method_url, params, headers)
        id = new_id('cn')
        credit_notes[id] = Data.mock_credit_note(params.merge(:id => id))
      end

      def get_credit_note(route, method_url, params, headers)
        route =~ method_url
        id = $1
        assert_existence :credit_note, id, credit_notes[id]
      end

      def list_credit_notes(route, method_url, params, headers)
        params[:offset] ||= 0
        params[:limit] ||= 10

        result = credit_notes.clone

        if params[:customer]
          result.delete_if { |k,v| v[:customer] != params[:customer] }
        end

        Data.mock_list_object(result.values, params)
      end

      def update_credit_note(route, method_url, params, headers)
        route =~ method_url
        id = $1
        assert_existence :credit_note, id, credit_notes[id]
        credit_notes[id].merge!(params)
      end

      def void_credit_note(route, method_url, params, headers)
        route =~ method_url
        id = $1
        assert_existence :credit_note, id, credit_notes[id]
        credit_notes[id].merge!(status: 'void', voided_at: Time.now.utc.to_i)
      end
    end
  end
end
