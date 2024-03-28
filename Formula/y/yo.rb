require "language/node"

class Yo < Formula
  desc "CLI tool for running Yeoman generators"
  homepage "https://yeoman.io"
  url "https://registry.npmjs.org/yo/-/yo-5.0.0.tgz"
  sha256 "4395888eda54803a590d20d92b285c4abebd81402908b5becdf9cbc6cbeba65f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3952f75866cc905302121f85682493adffe8f27e1f4d32109fecfb1604692cd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3952f75866cc905302121f85682493adffe8f27e1f4d32109fecfb1604692cd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3952f75866cc905302121f85682493adffe8f27e1f4d32109fecfb1604692cd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b66073b40d522594a57debc8312dbbd7799f9ed75fcc7e58f82834428aa41d3"
    sha256 cellar: :any_skip_relocation, ventura:        "7b66073b40d522594a57debc8312dbbd7799f9ed75fcc7e58f82834428aa41d3"
    sha256 cellar: :any_skip_relocation, monterey:       "7b66073b40d522594a57debc8312dbbd7799f9ed75fcc7e58f82834428aa41d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3952f75866cc905302121f85682493adffe8f27e1f4d32109fecfb1604692cd3"
  end

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
