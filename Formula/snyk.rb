require "language/node"

class Snyk < Formula
  desc "CLI and build-time tool to find & fix known vulnerabilities in open-source dependencies"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.136.1.tgz"
  sha256 "05a347ae082533f50e7132fc86370b244a910f6d430d5747d63423a3a451feaa"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Try running `snyk wizard` to define a Snyk protect policy", shell_output("#{bin}/snyk policy", 1)
  end
end
