class CreateSupportRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :support_requests do |t|
      t.string :email, comment: "The email of the person who created the support request"
      t.string :subject, comment: "The subject of the support request"
      t.text :body, comment: "The body of the support request"
      t.references :order, foreign_key: true, comment: "their most recent order, if applicable"
      t.timestamps
    end
  end
end
