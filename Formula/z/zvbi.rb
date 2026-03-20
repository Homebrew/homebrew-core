class Zvbi < Formula
  desc "Vertical Blanking Interval (VBI) decoding library"
  homepage "https://github.com/zapping-vbi/zvbi"
  url "https://github.com/zapping-vbi/zvbi/archive/refs/tags/v0.2.44.tar.gz"
  sha256 "bca620ab670328ad732d161e4ce8d9d9fc832533cb7440e98c50e112b805ac5e"
  license "GPL-2.0-or-later"
  head "https://github.com/zapping-vbi/zvbi.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "f7803981991063b4265a50a8b870311edc8afafe9362c7334f768f8b6322b27f"
    sha256 arm64_sequoia: "a8be8e1c10d76737f9b54ecfb5871b2e0598f76dabaae15b41f8e0c2cd6393b5"
    sha256 arm64_sonoma:  "67ede4426aa1d02ed9563d16ec686d245ed8eec54efba20ed24af2470f1c2078"
    sha256 sonoma:        "337e382234bbce4a697bfb11013c522d303ff922f953dfff0d03817c6a933168"
    sha256 arm64_linux:   "a1d79ee36f8a7b4611c73d5bbe9e2d7bd9572bd4f3763a51fc894c32d4c4b37a"
    sha256 x86_64_linux:  "f5ee604a80ba6c9d1d36d125953b4ca446d7d250cd5fe0797af9dae285e642a4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "libpng"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lzvbi", "-I#{include}", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
