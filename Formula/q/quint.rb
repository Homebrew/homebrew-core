class Quint < Formula
  desc "Core tool for the Quint specification language"
  homepage "https://quint-lang.org"
  url "https://registry.npmjs.org/@informalsystems/quint/-/quint-0.33.1.tgz"
  sha256 "a219b8566a2e559840a46ee85fc70e7e202c7c02e01e3eb9d393fa32ef692bd6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "02fced92f8b9a486d58374f5c919c014a5e99345702d2c7e7c2e1ee3ab30b8eb"
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
