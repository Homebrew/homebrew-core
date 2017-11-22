class Remake < Formula
  desc "GNU Make with improved error handling, tracing, and a debugger"
  homepage "https://bashdb.sourceforge.io/remake"
  url "https://downloads.sourceforge.net/project/bashdb/remake/4.2%2Bdbg-1.4/remake-4.2.1%2Bdbg-1.4.tar.bz2"
  version "4.2.1-1.4"
  sha256 "55df3b2586ab90ac0983a049f1911c4a1d9b68f7715c69768fbb0405e96a0e7b"

  bottle do
    sha256 "0833fb8f15c06fca9c97627ffdc9fc53e3a27feed22939ddf92b8aff84898cf3" => :high_sierra
    sha256 "de499d499d391b95f1da22ea69e7c4f700b4adebb4c7054001f8fefad157cd06" => :sierra
    sha256 "5409f2e163381938a90b049ef127e21250e05aefc00f1eff87e31e2921a29121" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all:
      \techo "Nothing here, move along"
    EOS
    system bin/"remake", "-x"
  end
end
