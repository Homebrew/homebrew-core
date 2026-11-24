class Quint < Formula
  desc "Core tool for the Quint specification language"
  homepage "https://quint-lang.org"
  url "https://registry.npmjs.org/@informalsystems/quint/-/quint-0.34.0.tgz"
  sha256 "845ecadc2af9a57317e8db84d4d90f8bde8476e90f8248bbf82b0eef100cf5da"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "7fadaa99a67398da9afa319b74e4ea26116a9cd825a243e1ee3ca3730415922a"
    sha256 cellar: :any_skip_relocation, all: "2fc44746019cf8ec884e4b1b8dd478efcea67b4fb2838735398ee89efca337b6"
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
