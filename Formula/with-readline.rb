class WithReadline < Formula
  desc "Allow GNU Readline to be used with arbitrary programs"
  homepage "https://www.greenend.org.uk/rjk/sw/withreadline.html"
  url "https://www.greenend.org.uk/rjk/sw/with-readline-0.1.1.tar.gz"
  sha256 "d12c71eb57ef1dbe35e7bd7a1cc470a4cb309c63644116dbd9c88762eb31b55d"
  revision 2

  bottle do
    cellar :any
    sha256 "3a6e8e8e2d6f35ecd215b969c3794e586b1209820a9b0e5d935ddc5363f58678" => :mojave
    sha256 "72ea8c0cce2f94fae5c963a1113c9b2504f1d728234c3c511ad7e3d5dca0d74b" => :high_sierra
    sha256 "808a3a96b1d247f16c0a3e21eb18ed287f7df474b36c4685725768a05c3c1c61" => :sierra
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
