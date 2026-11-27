class SafeChain < Formula
  desc "Malware protection for npm, yarn, pnpm, pip, uv and other package managers"
  homepage "https://github.com/AikidoSec/safe-chain"
  url "https://registry.npmjs.org/@aikidosec/safe-chain/-/safe-chain-1.5.30.tgz"
  sha256 "ddfbf12a4e23a698dafb907c9753e763c2a250fd1600401632c8e172a2395948"
  license "AGPL-3.0-or-later"

  bottle do
    manifest_sha256 "7e832771d6293d9cb273cae0cba5e2d802219ccaf536c7cc5eec98e7b8d8fb07"
    sha256 cellar: :any_skip_relocation, all: "bfcc2e9417095578c388f32c72e305c698446890a77d4a04ac2ea36f21ccec28"
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
