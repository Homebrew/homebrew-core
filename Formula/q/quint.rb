class Quint < Formula
  desc "Core tool for the Quint specification language"
  homepage "https://github.com/informalsystems/quint"
  url "https://registry.npmjs.org/@informalsystems/quint/-/quint-0.30.0.tgz"
  sha256 "0f6e9138330a718cbb813e1aebc13a2d475aad120a53cddf9cc03e188cfe0815"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e9b8d9b394e933864f5d634ab1e5b4e9c3863e5a511b7a3da69b616464023399"
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

    out = shell_output("#{bin}/quint run bank.qnt --invariant=no_negatives --mbt --verbosity 1")

    assert_match "No violation found", out
  end
end
