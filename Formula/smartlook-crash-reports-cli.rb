require "language/node"

class SmartlookCrashReportsCli < Formula
  desc "CLI tool for uploading crash mapping files to the Smartlook"
  homepage "https://www.npmjs.com/package/@smartlook/smartlook-crash-reports-cli"
  url "https://registry.npmjs.org/@smartlook/smartlook-crash-reports-cli/-/smartlook-crash-reports-cli-2.1.3.tgz"
  sha256 "77e4f67721be3cd526e49a38967ebd35549386a22cae06be1d2d89f1e65c0f5a"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/smartlook-crash-reports --version")
    assert_match("2.1.3", output.strip)
  end
end
