class Readpe < Formula
  desc "PE analysis toolkit"
  homepage "https://github.com/mentebinaria/readpe"
  url "https://github.com/mentebinaria/readpe/archive/refs/tags/v0.82.tar.gz"
  sha256 "6ee625acedb3cbe636afe41f854b6eed5aac466d7fad52e3a48557083f8acecc"
  license "GPL-2.0-or-later"
  head "https://github.com/mentebinaria/readpe.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "85d348756150c1b21aacea9f81f749e2236116cb1dadfb57e98d3aece8157ec8"
    sha256 arm64_monterey: "b28d3faa79d3685b5d6e08e12b35ebb916fc81e4549cff92ec70d37559e405f6"
    sha256 arm64_big_sur:  "71230992d921c7b7791b02b2bdb37db43385a4e61ab4e0ae9f1ef8d214527fa4"
    sha256 ventura:        "f4fece3b9252d4ab298d60e7162af4311b08082a5edf31bae639445e1e988f2f"
    sha256 monterey:       "f129d78170eaa0db46a1b318ead3dce0d7477cecb490da17f2cd186e350b944d"
    sha256 big_sur:        "e8c800ea2146ad608255235de5baf8d76a699131d1e4de3fb02a8930ee5d357e"
    sha256 x86_64_linux:   "10ec70b2f17afb4c78aa41dbef90f066ae1ddac31877a048a9b68d36bb00f4bb"
  end

  depends_on "openssl@3"

  resource "homebrew-testfile" do
    url "https://the.earth.li/~sgtatham/putty/0.78/w64/putty.exe"
    sha256 "fc6f9dbdf4b9f8dd1f5f3a74cb6e55119d3fe2c9db52436e10ba07842e6c3d7c"
  end

  def install
    ENV.deparallelize
    inreplace "lib/libpe/Makefile", "-flat_namespace", ""
    system "make", "prefix=#{prefix}", "CC=#{ENV.cc}"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    resource("homebrew-testfile").stage do
      assert_match(/Bytes in last page:\s+120/, shell_output("#{bin}/readpe ./putty.exe"))
    end
  end
end
