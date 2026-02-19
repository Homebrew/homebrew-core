class Sratom < Formula
  desc "Library for serializing LV2 atoms to/from RDF"
  homepage "https://drobilla.net/software/sratom.html"
  url "https://download.drobilla.net/sratom-0.6.22.tar.xz"
  sha256 "0209b7d0f22c96abb416722ed735b0933be47931ecff4aa4b26ded7760b4f252"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?sratom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "44de40b23201133a3e6186c80df57447648e7384b1f25855651b19cd6feec9b3"
    sha256 cellar: :any, arm64_sequoia: "00eb48d6d7b4806436f5b5643bee8a27d53e34258e2499e47c6f8df54736def8"
    sha256 cellar: :any, arm64_sonoma:  "90e34a6c3597eb474ac078c44f7edf6dad1325d3c719745aa48bba1ac476c3be"
    sha256 cellar: :any, sonoma:        "9dc0af1d51b8ea37c1d77bbe218e1d37a76c3a6084b79f978ac2c08bec13ceec"
    sha256               arm64_linux:   "3787ba541ba92cf6380be36fd9c9b89d08ea51774dbaaa1c3f55c1090ae02931"
    sha256               x86_64_linux:  "2c9f730f160ea12627f0f03f512b393f487609b60b83d127790848feaeb48e81"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"

  def install
    system "meson", "setup", "build", "-Dtests=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <sratom/sratom.h>

      int main()
      {
        return 0;
      }
    C

    pkg_config_cflags = shell_output("pkg-config --cflags --libs sratom-0").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end
