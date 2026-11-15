class Zvbi < Formula
  desc "Vertical Blanking Interval (VBI) decoding library"
  homepage "https://github.com/zapping-vbi/zvbi"
  url "https://github.com/zapping-vbi/zvbi/archive/refs/tags/v0.2.46.tar.gz"
  sha256 "817a26118e2654155ee761cd39414885986a4315fdb6617af5314090ddfffd10"
  license "GPL-2.0-or-later"
  head "https://github.com/zapping-vbi/zvbi.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "155d876fb904681a9a95ab7072c341ae82a0425320078664fe6e95726b21799f"
    sha256 arm64_tahoe:       "d2bec4ffa3e7835411ec1661dd92ddedacb5b49b2b4aa3537657ff00507d90fb"
    sha256 arm64_sequoia:     "dd3f630afe948a740915195ef9836aee07893cf1a4e21a8f34939eb372b65697"
    sha256 arm64_linux:       "63772cf6df5e65fb32d0f3682b924ac4cc28f54f6a6034fd8e8ffa8c6b274a2a"
    sha256 x86_64_linux:      "055ae4e06020a7103ee3bdcb28a70839900f746516c51f7b0b67c2b0f33bee8f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libpng"

  on_macos do
    depends_on "gettext"
  end

  deny_network_access!

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libzvbi.h>
      #include <stdio.h>

      int main() {
        unsigned int major, minor, micro;
        vbi_version(&major, &minor, &micro);
        printf("%u.%u.%u\\n", major, minor, micro);

        vbi_decoder *dec = vbi_decoder_new();
        if (!dec) {
          fprintf(stderr, "vbi_decoder_new failed\\n");
          return 1;
        }
        vbi_decoder_delete(dec);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lzvbi", "-I#{include}", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
