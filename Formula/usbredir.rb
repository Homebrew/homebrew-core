class Usbredir < Formula
  desc "USB traffic redirection library"
  homepage "https://www.spice-space.org"
  url "https://www.spice-space.org/download/usbredir/usbredir-0.8.0.tar.bz2"
  sha256 "87bc9c5a81c982517a1bec70dc8d22e15ae197847643d58f20c0ced3c38c5e00"

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "libusb"

  def install
    # https://stackoverflow.com/questions/15860127/how-to-configure-tcp-keepalive-under-mac-os-x
    inreplace "usbredirserver/usbredirserver.c" do |s|
      s.gsub! "SOL_TCP", "IPPROTO_TCP"
      s.gsub! "TCP_KEEPIDLE", "TCP_KEEPALIVE"
    end

    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <usbredirparser.h>
      int main() {
        return usbredirparser_create() ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.cpp",
                   "-L#{lib}",
                   "-lusbredirparser",
                   "-o", "test"
    system "./test"
  end
end
