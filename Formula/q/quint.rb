class Quint < Formula
  desc "Core tool for the Quint specification language"
  homepage "https://github.com/informalsystems/quint"
  url "https://registry.npmjs.org/@informalsystems/quint/-/quint-0.29.1.tgz"
  sha256 "4f136b1b666e1c4c9a142dfdfa7376ffc71728e74b39b1974adf7586d55625f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3cd146ea3e0d2d16c317857c2b572a6dfcf538d88dfcf955123a071756206aa3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quint --version")

    (testpath/"bank.qnt").write <<~QNT
      module bank {
        var balances: str -> int
        pure val ADDRESSES = Set("alice", "bob", "charlie")

        action deposit(account, amount) = {
          balances' = balances.setBy(account, curr => curr + amount)
        }

        action withdraw(account, amount) = all {
          balances.get(account) >= amount,
          balances' = balances.setBy(account, curr => curr - amount),
        }

        action init = { balances' = ADDRESSES.mapBy(_ => 0) }

        action step = {
          nondet account = ADDRESSES.oneOf()
          nondet amount = 1.to(100).oneOf()
          any { deposit(account, amount), withdraw(account, amount) }
        }

        val no_negatives = ADDRESSES.forall(addr => balances.get(addr) >= 0)
      }
    QNT

    out = shell_output("#{bin}/quint run bank.qnt --invariant=no_negatives --mbt --verbosity 1")

    assert_match "No violation found", out
  end
end
