class Readpe < Formula
  desc "PE analysis toolkit"
  homepage "https://github.com/mentebinaria/readpe"
  url "https://github.com/mentebinaria/readpe/archive/refs/tags/v0.85.1.tar.gz"
  sha256 "3218099d94c81488a4b042d86f64a4076835e1f2f2aff8ed4d58f01c20567507"
  license "GPL-2.0-or-later"
  head "https://github.com/mentebinaria/readpe.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "5611f03dabb2f615b6b399a85d937b1772eca7f1ddaeb86f6c9883ad2d1dea03"
    sha256 arm64_sequoia: "4de2c90e7d61718d3fe23d6214e7746f2aae25d656e2a7fded40dbb7ca1c8aaa"
    sha256 arm64_sonoma:  "f3e402c3d41573a09bbf3c1f0e6afc605ec997eb0907891beaa0868bcda8d162"
    sha256 sonoma:        "5600fcc6f348209569f4254cee52ea00caccffa571e6bf8c92b34e70aae463d7"
    sha256 arm64_linux:   "4056c6fc785ef850a79932f696a7b18ddddd2464ed2e875b3521f03178cd8ba1"
    sha256 x86_64_linux:  "a4b822686f470e7e03ce964e8fbb067e16a74d2e295ca8b6ef418a13df604384"
  end

  depends_on "openssl@4"

  def install
    ENV.deparallelize
    inreplace "lib/libpe/Makefile", "-flat_namespace", ""
    system "make", "prefix=#{prefix}", "CC=#{ENV.cc}"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    resource "homebrew-testfile" do
      url "https://the.earth.li/~sgtatham/putty/0.78/w64/putty.exe"
      sha256 "fc6f9dbdf4b9f8dd1f5f3a74cb6e55119d3fe2c9db52436e10ba07842e6c3d7c"
    end

    resource("homebrew-testfile").stage do
      assert_match(/Bytes in last page:\s+120/, shell_output("#{bin}/readpe ./putty.exe"))
    end
  end
end
