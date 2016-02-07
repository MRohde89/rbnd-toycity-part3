class Wallet

  attr_reader :money

  @@wallet

  def initialize(money = 1000)
    @@wallet = money
  end

    def self.change_money(amount)
      if @@wallet-amount > 0 ? @@wallet += amount : (raise NoMoneyError, "Can not do transaction with amount #{amount}, because it exceeds current wallet (current cash: #{@@wallet.show})")
      end
    end

  def self.show
    return @@wallet
  end

end
