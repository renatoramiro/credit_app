# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CreditApp.Repo.insert!(%CreditApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

user = CreditApp.Repo.insert!(%CreditApp.User{identity_document: "123456", phone: "123456", enabled: true})
client = CreditApp.Repo.insert!(%CreditApp.Client{name: "AA", address: "AA", credit: 10.1, user_id: user.id})


user2 = CreditApp.Repo.insert!(%CreditApp.User{identity_document: "234567", phone: "234567", enabled: true})
client2 = CreditApp.Repo.insert!(%CreditApp.Client{name: "BB", address: "BB", credit: 10.1, user_id: user2.id})

CreditApp.Repo.insert!(%CreditApp.Transaction{value: 3, client_id: client.id, transaction_id: client2.id})