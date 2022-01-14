module StripeMock
  module RequestHandlers
    module Helpers

      def add_reversal_to_transfer(reversal, transfer)
        reversals = transfer[:reversals]
        reversals[:data] << reversal
        reversals[:total_count] = reversals[:data].count

        transfer[:amount_reversed] = reversals[:data].pluck(:amount).map(&:to_i).sum
        transfer[:reversed] = true
      end
    end
  end
end