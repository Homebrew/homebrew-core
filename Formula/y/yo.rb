require "language/node"

class Yo < Formula
  desc "CLI tool for running Yeoman generators"
  homepage "https://yeoman.io"
  url "https://registry.npmjs.org/yo/-/yo-5.0.0.tgz"
  sha256 "4395888eda54803a590d20d92b285c4abebd81402908b5becdf9cbc6cbeba65f"
  license "BSD-2-Clause"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yo --version")
    assert_match "Everything looks all right!", shell_output("#{bin}/yo doctor")
  end
end
