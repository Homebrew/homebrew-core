class WithReadline < Formula
  desc "Allow GNU Readline to be used with arbitrary programs"
  homepage "https://www.greenend.org.uk/rjk/sw/withreadline.html"
  url "https://www.greenend.org.uk/rjk/sw/with-readline-0.1.1.tar.gz"
  sha256 "d12c71eb57ef1dbe35e7bd7a1cc470a4cb309c63644116dbd9c88762eb31b55d"
  revision 2

  bottle do
    cellar :any
    sha256 "e506a5122a3e7ee13444f56886e966484fb68aa293d2ebeea46d4762f020fb37" => :mojave
    sha256 "5db12ee438dc08ac90196940f9ff868c3169f3e77fbbd0b5ae1c6cde21dd96cf" => :high_sierra
    sha256 "2f1e93e551ea44fbd5594fe734e8dd68d0cd741747a770bf2725be05bd00db04" => :sierra
    sha256 "692f55b5ea8d97d2f19edea8c5ab6041b5efb3242aedb43feee0e5956e1e590b" => :el_capitan
    sha256 "05cd5dac85256b656838e839a81cd5abdc22caa3d916e7316f7ce517d17f6059" => :yosemite
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    pipe_output("#{bin}/with-readline /usr/bin/expect", "exit", 0)
  end
end
