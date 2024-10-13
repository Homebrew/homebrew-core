class Readpe < Formula
  desc "PE analysis toolkit"
  homepage "https://github.com/mentebinaria/readpe"
  url "https://github.com/mentebinaria/readpe/archive/refs/tags/v0.84.tar.gz"
  sha256 "2d0dc383735802db62234297ae1703ccbf4b6d2f2754e284eb90d6f0a57aa670"
  license "GPL-2.0-or-later"
  head "https://github.com/mentebinaria/readpe.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "a68a6f0b54b9428abfeca6dccbac97567ecfafc1b0d2871706dd0f22f65d7c9e"
    sha256 arm64_sonoma:   "23cc8ab364a477bd245a3771e0fefd945849f6feab70b1288f6db421f1f1a71c"
    sha256 arm64_ventura:  "8dbca0ad687464fff69c0b7092ff9f08aa76f9eb50595836e239dfd957514032"
    sha256 arm64_monterey: "809b896ec49463d5f5246236b6da178b6e34e97df8807ff2b1a3b26ec3342a3a"
    sha256 sonoma:         "fa76a24e56248862f78f3533071511bbb799a7dc7cf73e7053ce20075df5c36a"
    sha256 ventura:        "853736579e5cf2720e23fdc87b76743df8f2da3cd443f7800534b5d12f5c1c0f"
    sha256 monterey:       "ec16bb320368c12138d4d78c7cd1d8d93df6ea966f257d3b15bf0772084a0002"
    sha256 x86_64_linux:   "7f4cb2c34a30a64949fe31d4597454732c7e99f1bbe3b450d317a9e4f0da5d61"
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
