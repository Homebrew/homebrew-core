class SafeChain < Formula
  desc "Malware protection for npm, yarn, pnpm, pip, uv and other package managers"
  homepage "https://github.com/AikidoSec/safe-chain"
  url "https://registry.npmjs.org/@aikidosec/safe-chain/-/safe-chain-1.5.29.tgz"
  sha256 "e2cbe14706eeec5bb99e8b2f28e00e12c4d665935122e127811bf444b432cdc7"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6f7d34dee1f197e95ff57e45d79b1e05bee1bd79a1e1fdfd653aeeb7747e1ac7"
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
