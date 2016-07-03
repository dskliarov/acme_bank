defmodule BankWeb.AccountControllerTest do
  use BankWeb.ConnCase
  alias BankWeb.{Customer, Deposit, Ledger, Repo}

  @moduletag isolation: :serializable

  test "show", %{conn: conn} do
    alice = Customer.build(%{username: "alice"}) |> Repo.insert!
    {:ok, _} = Deposit.build(alice, ~M"10 USD") |> Ledger.write

    conn = conn |> assign(:current_customer, alice)

    conn = get conn, "/account"
    assert conn.status == 200
    assert conn.resp_body =~ "<h2>Account balance</h2>\n\n$10.00"
    assert conn.resp_body =~ "Deposit"

    # TODO: allow custom deposit description and assert it here
  end

  test "unauthenticated", %{conn: conn} do
    conn = get conn, "/account"
    assert conn.status == 401
  end
end
