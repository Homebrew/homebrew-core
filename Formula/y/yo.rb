class Yo < Formula
  desc "CLI tool for running Yeoman generators"
  homepage "https://yeoman.io"
  url "https://registry.npmjs.org/yo/-/yo-6.0.0.tgz"
  sha256 "db7b3bf350eb65def5b4dff427d5c164884937a713a72a018cec9271a3a53ebc"
  license "BSD-2-Clause"
  head "https://github.com/yeoman/yo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5d1fcc62b691e174aca6bf03f7c42e4e5ec5acae1f71ba026292c6f9ee1b2c99"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yo --version")
    assert_match "Everything looks all right!", shell_output("#{bin}/yo doctor")
  end
end
