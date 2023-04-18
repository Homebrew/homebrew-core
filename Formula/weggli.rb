class Weggli < Formula
  desc "Fast and robust semantic search tool for C and C++ codebases"
  homepage "https://github.com/googleprojectzero/weggli"
  url "https://github.com/googleprojectzero/weggli/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "12fde9a0dca2852d5f819eeb9de85c4d11c5c384822f93ac66b2b7b166c3af78"
  license "Apache-2.0"
  head "https://github.com/googleprojectzero/weggli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b85863bb8393ee053190a070ec0fcc44d7d7c78709df4f50e4811301edcf7652"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d71e7a726a9745ad22a4a7db9beec29730d0147b49088614a4dda3ad16da59f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7035dc61b7193c31af0c5e50e655b73b219e67accb597eb937f8bcada03e770b"
    sha256 cellar: :any_skip_relocation, ventura:        "b2ec4a783dad5f1169dc0b1f70ecb6038632297e82ffea4e70c94d07ec1a1c7f"
    sha256 cellar: :any_skip_relocation, monterey:       "58fd6b690d5a4a5a92660d701c2e6627e9e9076a5c935e24298d2123227ce723"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4f54dbc53220583652199f660a9cf93abcb084042b5e6a9744cd6fe5fdefb95"
    sha256 cellar: :any_skip_relocation, catalina:       "7b448b48f07b5666060ac479e17315929c0cac62da574a9a0807728e189231ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "070a5c12e89cdbd218bb7a07903f58718bbd83abeb6dfeb58f6b8d7cdd1077ff"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.c").write("void foo() {int bar=10+foo+bar;}")
    system "#{bin}/weggli", "{int $a = _+foo+$a;}", testpath/"test.c"
  end
end
