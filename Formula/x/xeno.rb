class Xeno < Formula
  desc "A CLI tool designed for the Xeno-Canto"
  homepage "https://github.com/siansiansu/go-xeno"
  url "https://github.com/siansiansu/go-xeno/releases/download/v1.0.0/go-xeno-1.0.0.tar.gz"
  sha256 "cc23c57565b80b9a62f6b31b4aeae7243455f1b504827c65209d9c2aeb1eb89e"
  version "1.0.0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30b79776733e646c74b5f9075f0e8f53e006b1eb0420cf994d1145f7c9967c7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30b79776733e646c74b5f9075f0e8f53e006b1eb0420cf994d1145f7c9967c7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30b79776733e646c74b5f9075f0e8f53e006b1eb0420cf994d1145f7c9967c7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc23c57565b80b9a62f6b31b4aeae7243455f1b504827c65209d9c2aeb1eb89e"
    sha256 cellar: :any_skip_relocation, ventura:        "cc23c57565b80b9a62f6b31b4aeae7243455f1b504827c65209d9c2aeb1eb89e"
    sha256 cellar: :any_skip_relocation, monterey:       "cc23c57565b80b9a62f6b31b4aeae7243455f1b504827c65209d9c2aeb1eb89e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70a0d3e0199a8c859bf7f658bc920a0d9239703c953f9c12b8d85caab42f6618"
  end

  def install
    system "make", "install"
  end

  test do
    assert_match "xeno version v1.0.0", shell_output("#{bin}/xeno --version")

    # xeno use the args[0] as the search query for the xeno-canto website
    # Since it is an empty we expect it to be invalid
    assert_match 'please input the search query! Example: xeno "Taiwan blue magpie"', shell_output("#{bin}/xeno")
  end
end
