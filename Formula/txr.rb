class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-277.tar.bz2"
  sha256 "96958f80ee5293f29496b52a8bf2b1fb361a49d3cb13c3fe2b2087937016d4eb"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "1dc3443550c5d1096ac22909cd1bc8bfdab93d5334de7a4cd9a9cb225ba585c4"
    sha256 cellar: :any, arm64_big_sur:  "487d1417e2ddcae89ebbc4f2a10d0d22b7ea2abd3bcca0e91be1b618593b94c4"
    sha256 cellar: :any, monterey:       "5585d076623221ff9ae0385804c364e1d416eefcd5aceb3e0a745b1eb6f8def8"
    sha256 cellar: :any, big_sur:        "983e071c4f37300adfba91885daf603e70b87d73ba7a857bceaa737cc332f649"
    sha256 cellar: :any, catalina:       "ef8e91d06bb80bf3b6f809a7f63e4c8ea0669692cfd8d85d9b8a23b29a51930e"
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
