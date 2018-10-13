require "language/node"

class ResinCli < Formula
  desc "The official resin.io CLI tool"
  homepage "https://docs.resin.io/reference/cli/"
  url "https://registry.npmjs.org/resin-cli/-/resin-cli-7.10.6.tgz"
  version "7.10.6"
  sha256 "011f79bfb1a75ad077b82afdc42695ce6061a522ccb1671a4e6d47e3e39f0889"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Logging in to resin.io", pipe_output("#{bin}/resin login")
  end
end
