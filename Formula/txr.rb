class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-272.tar.bz2"
  sha256 "86e9bdc590c4882ae365e3425f920bbb23440c5395023990bc0f534fee92b0f5"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "0eeb940a2ee8b2dd1214ae0e4424812056821540e6099983ed6e0aa1adb32d0b"
    sha256 cellar: :any, arm64_big_sur:  "1ad2cfb5cff8120570801ecc1e54f41044c42db53c29dea3c18493eb28e0baa7"
    sha256 cellar: :any, monterey:       "cc09a98fee686eb9cd990f3c1b9e9cae70aa8df14a076ebf4f0cb35ea241de49"
    sha256 cellar: :any, big_sur:        "92c8d2d38cf489bc0e2803c9a328684deeab4a8e404b23ad05b08aa22905cc9b"
    sha256 cellar: :any, catalina:       "f847f91fa598d4b425641c0c7fb7456ea10670a00c12c0e7f4b4ff5354602edd"
  end

  depends_on "libffi"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--inline=static inline"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
