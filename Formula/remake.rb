class Remake < Formula
  desc "GNU Make with improved error handling, tracing, and a debugger"
  homepage "https://bashdb.sourceforge.io/remake"
  url "https://downloads.sourceforge.net/project/bashdb/remake/4.1%2Bdbg-1.2/remake-4.1%2Bdbg1.2.tar.bz2"
  version "4.1-1.2"
  sha256 "cc6bae282c064b66a3d058133d682fc445b8cf8916f5a875150c379dcf7b4a9e"

  bottle do
    sha256 "1156ef1cdfbf32c8a2e2ddb842dd34ef7f4d88ad8d3d3865ded4de46a8a0123e" => :high_sierra
    sha256 "50aca3e89fb405911a8cba1cef1cab204a5a93fd9b79df871a53119c7f04a785" => :sierra
    sha256 "c7238548e920287581ca97dcd0464fc84e1456e8bf097e37cb37dde6b290eb52" => :el_capitan
    sha256 "4dac4fdd06520c8426c227ed4bc1f7db5421e7cca8003190cbce0f6e32046fda" => :yosemite
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"Makefile").write <<-EOS.undent
      all:
      \techo "Nothing here, move along"
    EOS
    system bin/"remake", "-x"
  end
end
