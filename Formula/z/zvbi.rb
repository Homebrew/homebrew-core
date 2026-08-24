class Zvbi < Formula
  desc "Vertical Blanking Interval (VBI) decoding library"
  homepage "https://github.com/zapping-vbi/zvbi"
  url "https://github.com/zapping-vbi/zvbi/archive/refs/tags/v0.2.45.tar.gz"
  sha256 "e6c954fde2a5a635187f19e1ab870a88c1a982012c5f1b33b8f2513e0ab7a50e"
  license "GPL-2.0-or-later"
  head "https://github.com/zapping-vbi/zvbi.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "7a8505a7d69d87fba9b5ed97148c63c46fd02f9860741d82db56eb9dc8420f29"
    sha256 arm64_sequoia: "32d17a82f7430faec2967ac3363ce754eaa78725982426e5e5d8673e3a16262a"
    sha256 arm64_sonoma:  "66900bf5508d5ef6e2e174f32c9c3c6a90126e597efa06649bb320c695ff91c6"
    sha256 sonoma:        "be8e1fd4322262923fa4d6b522f89885459e43744cb651f711f6dab44eae6fae"
    sha256 arm64_linux:   "0690cf0aa3367d0a12050b956a0c70c4c58b3a28f6899590db02b97fdcc1606f"
    sha256 x86_64_linux:  "cabf02e624c57195717629973f1dd6f25e22d5b3ca831a1a0e1a4e6a9c5c7521"
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
