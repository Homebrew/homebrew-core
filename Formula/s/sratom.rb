class Sratom < Formula
  desc "Library for serializing LV2 atoms to/from RDF"
  homepage "https://drobilla.net/software/sratom.html"
  url "https://download.drobilla.net/sratom-0.6.20.tar.xz"
  sha256 "3826e9186cabc43ca5e359fcc3d8238060232f5f8a2090be5dc9ab390e5b6477"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?sratom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d9e520c708784f95cf4e96d31fc1ff029eaef5e6c8a9b8cfe9fd956e169a483e"
    sha256 cellar: :any, arm64_sequoia: "8f6d3fdb8894a7a626964ce4b3a8861ffbbb6e80886dd1c62998534eb575997d"
    sha256 cellar: :any, arm64_sonoma:  "ae1ba306b125b0771afeafd7bf27499e5c473233b53a81f7cba94f221b96e8cc"
    sha256 cellar: :any, sonoma:        "9fea71d288192844ba2ec677a08e5502c19251e16ccf6c85c81f672b408ddf38"
    sha256               arm64_linux:   "445375ef4112a1357d7cc9a8e72a98780572c554c49676810e36940f547c57bf"
    sha256               x86_64_linux:  "da7731af732857f9c095f8e56b7f1dc1c9d01b8cf62c59b0111aee21fc0cb839"
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
