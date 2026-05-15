class Quint < Formula
  desc "Core tool for the Quint specification language"
  homepage "https://github.com/informalsystems/quint"
  url "https://registry.npmjs.org/@informalsystems/quint/-/quint-0.32.0.tgz"
  sha256 "244b734b25915e4afa8ee4dbce07fef1ca69df1c7f186cd36e578b0bd37c0bf5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fa6ed9e38ff62eb0886c5a879f79e25c1c2d98d949ba4cf43d0d10b0d5184416"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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

    out = shell_output("#{bin}/quint compile bank.qnt")
    assert_match '"stage":"compiling"', out
    assert_match '"main":"bank"', out
  end
end
