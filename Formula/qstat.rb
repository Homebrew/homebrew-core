class Qstat < Formula
  desc "Query Quake servers from the command-line"
  homepage "https://github.com/multiplay/qstat"
  url "https://github.com/multiplay/qstat/archive/v2.16.tar.gz"
  sha256 "8982a8992c4bdff6d765607ef9e83a759b6fe6c92dedb1fcdd3824807bc286cf"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_big_sur: "6fe71871f75091ad1ceb3cdbfd10888917d886f7aafbe50e9cebc64f6c2fd438"
    sha256 big_sur:       "36be7f0db1783921f8f3273467eab54cb13a2b0280004e48c3fa4ad9dae11ca7"
    sha256 catalina:      "211cbd7cc45766390d9f16f1e3c49a174af9729d73de551ac66121518f44db40"
    sha256 mojave:        "0325cc3af11f7a59bd3cf8c3e01f26fcea70abb8aa8982a17e6e18e95515d123"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qstat", "--help"
  end
end
