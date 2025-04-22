class Sratom < Formula
  desc "Library for serializing LV2 atoms to/from RDF"
  homepage "https://drobilla.net/software/sratom.html"
  url "https://download.drobilla.net/sratom-0.6.18.tar.xz"
  sha256 "4c6a6d9e0b4d6c01cc06a8849910feceb92e666cb38779c614dd2404a9931e92"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?sratom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "06905bb6f394ffed730cf2b4e18f80d0bf8829ab1b68bbab7ef98f77e330eaee"
    sha256 cellar: :any, arm64_sonoma:  "dc753964055fb9efd570db02e1b9489d0b5454f543e4ca1c1ee5d89eb0ce0af3"
    sha256 cellar: :any, arm64_ventura: "a16df9f144f66a5f40bcfa25e3b4474b55bbe5d076f00e9a4da01d49588af268"
    sha256 cellar: :any, sonoma:        "d534631148d36ab131d17128cbbf3cbf54b0d101f97eaf377ce5d92332f58cf2"
    sha256 cellar: :any, ventura:       "2628c0564c30338296d91bb61b737fc3c7c8d38ccc25f7bad06d4b94d51a3021"
    sha256               arm64_linux:   "9408b999aa14b1be28373764701877a1936724d00999725f83dbe629f00e2ca0"
    sha256               x86_64_linux:  "cb03a03254d0fe571376523b49d7363ed984ee238240c67f3e4c627b47f75c43"
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
