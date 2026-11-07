class SafeChain < Formula
  desc "Malware protection for npm, yarn, pnpm, pip, uv and other package managers"
  homepage "https://github.com/AikidoSec/safe-chain"
  url "https://registry.npmjs.org/@aikidosec/safe-chain/-/safe-chain-1.5.27.tgz"
  sha256 "141d989b18df553b6b77175d4bcb51c51f8fb043192b5f9aa4194a3eb79a3c7e"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5cd73cae1be7b1077dda597d4238829f654390e1c1cd946c7bd4bbb428d7f907"
  end

  depends_on "node"

  # The test starts a local proxy, which the network sandbox blocks.
  allow_network_access! [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  def caveats
    <<~EOS
      To wrap your package managers with safe-chain, run:
        safe-chain setup
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/safe-chain --version")

    (testpath/".safe-chain/malwareDatabase_npm.json").write <<~JSON
      [
        {
          "package_name": "evil-pkg",
          "version": "1.0.0",
          "reason": "MALWARE"
        }
      ]
    JSON
    ENV["SAFE_CHAIN_MALWARE_LIST_BASE_URL"] = "http://localhost:#{free_port}"

    output = shell_output("#{bin}/aikido-npm install evil-pkg@1.0.0 2>&1", 1)
    assert_match "Malicious changes detected:\n - evil-pkg@1.0.0", output
  end
end
