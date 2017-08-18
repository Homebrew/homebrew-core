require "language/node"

class Scolan < Formula
  desc "Sync clipboard over LAN"
  homepage "https://github.com/Cap32/scolan"
  url "https://registry.npmjs.org/scolan/-/scolan-0.0.0.tgz"
  version "0.0.0"
  sha256 "09da31c47ff34e2f097ebc428995da0adae4eee95ec4c2da8096ed75d1e639cb"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    raise "Test not implemented."
  end
end