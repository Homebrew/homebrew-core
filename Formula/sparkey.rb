class Sparkey < Formula
  desc "Constant key-value store, best for frequent read/infrequent write uses"
  homepage "https://github.com/spotify/sparkey/"
  url "https://github.com/spotify/sparkey/archive/sparkey-1.0.0.tar.gz"
  sha256 "d607fb816d71d97badce6301dd56e2538ef2badb6530c0a564b1092788f8f774"
  revision 1

  bottle do
    cellar :any
    sha256 "b7e64101995d257df010edb67bafcd60745f09c7b0ebb9650c817eb7343f1899" => :catalina
    sha256 "438c323c343b7aade2da46316d24bcc4d5c7a95910a43914d70125af14a17636" => :mojave
    sha256 "4acbb473ce3be942b808af45789ccb7ede8199c728f7c381cd0dda1a105c8a9e" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "snappy"

  def install
    system "autoreconf", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    mv bin/"bench", bin/"sparkey_bench"
  end

  test do
    system "#{bin}/sparkey", "createlog", "-c", "snappy", "test.spl"
    system "echo foo.bar | #{bin}/sparkey appendlog -d . test.spl"
    system "#{bin}/sparkey", "writehash", "test.spl"
    system "#{bin}/sparkey get test.spi foo | grep ^bar$"
  end
end
