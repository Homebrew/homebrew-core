class Ungit < Formula
  desc "Easiest way to use Git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://github.com/FredrikNoren/ungit/archive/refs/tags/v1.5.30.tar.gz"
  sha256 "960b9e459edca37712303e42845fe90ca4a31744e854aa204c0e259b40e90315"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2fd45c6ddef5ed4e9766abf5d6098cea756f93fd50156d24cd9c1721d75cd876"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    port = free_port
    spawn bin/"ungit", "--no-launchBrowser", "--port=#{port}"
    output = shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}/")
    assert_match "<title>ungit</title>", output
  end
end
