class Remake < Formula
  desc "GNU Make with improved error handling, tracing, and a debugger"
  homepage "https://bashdb.sourceforge.io/remake"
  url "https://downloads.sourceforge.net/project/bashdb/remake/4.2%2Bdbg-1.3/remake-4.2.1%2Bdbg-1.3.tar.bz2"
  version "4.2.1-1.3"
  sha256 "26874693fb9408f19d56fa5c76ee420a603cbbd226ab46d314658b96f9770df0"

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
    (testpath/"Makefile").write <<-EOS.undent
      all:
      \techo "Nothing here, move along"
    EOS
    system bin/"remake", "-x"
  end
end
