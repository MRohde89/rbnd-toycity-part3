class Wallet

  @@wallet = 0

  def initialize(money = 0)
    @@wallet = money
  end

    # DECREASES/INCREASES MONEY OF THE WALLET
    def self.change_cash(amount)
      # the amount needs to be the opposite, because if quantity is "-" then the wallet will increase
      if @@wallet-amount >= 0 ? @@wallet -= amount : (raise NoMoneyError, "Can not do transaction with amount #{amount}, because it exceeds current wallet (current cash: #{@@wallet})")
      end
    end

  # SHOWS MONEY IN WALLET
  def self.show
    return @@wallet
  end

end
