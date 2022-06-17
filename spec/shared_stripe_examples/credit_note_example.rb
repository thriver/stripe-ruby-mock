require 'spec_helper'

shared_examples 'Credit Note API' do
  context 'creating a credit note' do
    it 'creates a credit note' do
      invoice = Stripe::Invoice.create
      credit_note = Stripe::CreditNote.create(invoice: invoice.id)
      expect(credit_note.id).to match(/^test_cn/)
      expect(credit_note.invoice).to eq(invoice.id)
    end

    it "stores a created stripe invoice in memory" do
      invoice = Stripe::Invoice.create
      credit_note = Stripe::CreditNote.create(invoice: invoice.id)
      data = test_data_source(:credit_notes)
      expect(data[credit_note.id]).to_not be_nil
      expect(data[credit_note.id][:id]).to eq(credit_note.id)
    end
  end

  context "updating a credit note" do
    it "updates a stripe credit note" do
      invoice = Stripe::Invoice.create
      credit_note = Stripe::CreditNote.create(invoice: invoice.id, currency: 'cad')
      expect(credit_note.currency).to eq("cad")

      credit_note.currency = "usd"
      credit_note.save

      credit_note = Stripe::CreditNote.retrieve(credit_note.id)
      expect(credit_note.currency).to eq("usd")
    end
  end

  context 'voiding a credit note' do
    it 'marks the credit note as void' do
      invoice = Stripe::Invoice.create
      credit_note = Stripe::CreditNote.create(invoice: invoice.id)
      expect(credit_note.status).to eq('issued')

      Stripe::CreditNote.void_credit_note(credit_note.id)
      credit_note = Stripe::CreditNote.retrieve(credit_note.id)
      expect(credit_note.status).to eq('void')
      expect(credit_note.voided_at).not_to be_nil
    end
  end

  context 'retrieving a list of credit notes' do
    it 'retrieves a list of credit notes' do
      invoice = Stripe::Invoice.create
      credit_note = Stripe::CreditNote.create(invoice: invoice.id)
      credit_notes = Stripe::CreditNote.list
      expect(credit_notes.data.length).to eq(1)
      expect(credit_notes.data.first.id).to eq(credit_note.id)
    end
  end

  context 'retrieving a credit note' do
    it 'retrieves a credit note' do
      invoice = Stripe::Invoice.create
      credit_note = Stripe::CreditNote.create(invoice: invoice.id)
      credit_note = Stripe::CreditNote.retrieve(credit_note.id)
      expect(credit_note.id).to eq(credit_note.id)
    end
  end
end
