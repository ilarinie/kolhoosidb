json.user do
  json.id user.id
  json.name user.name
  json.username user.username
  json.email user.email
  json.created_at user.created_at
  json.updated_at user.updated_at
  json.communes user.communes
  json.invitations do
    json.array! user.invitations do |invitation|
      json.id invitation.id
      json.commune_name invitation.commune.name
      json.commune_id invitation.commune.id
      json.username invitation.user.username
    end
  end
  json.sent_refunds do
    json.array! sent_refunds do |refund|
      json.from refund.sender.name
      json.to refund.receiver.name
      json.amount refund.amount
    end
  end
  json.received_refunds do
    json.array! received_refunds do |refund|
      json.from refund.sender.name
      json.to refund.receiver.name
      json.amount refund.amount
    end
  end
end
