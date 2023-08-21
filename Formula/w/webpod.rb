require "language/node"

class Webpod < Formula
  desc "Deploy websites and apps anywhere"
  homepage "https://webpod.dev"
  url "https://registry.npmjs.org/webpod/-/webpod-1.0.0.tgz"
  sha256 "99b123e8d9f49b06d2dd0b886b81d2c2c64e510ba50eac2ba229e60b36719a7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "711340b7e1ecf3cdf3f1b38d05abc4b2ab17831b172839bb9b5a9c5d0e6ff5fe"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/webpod --version")

    status_output = shell_output("#{bin}/webpod fakehost 2>&1", 1)
    assert_match "Webpod cannot connect to root@fakehost", status_output
  end
end
