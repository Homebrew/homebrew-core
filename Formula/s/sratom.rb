class Sratom < Formula
  desc "Library for serializing LV2 atoms to/from RDF"
  homepage "https://drobilla.net/software/sratom.html"
  url "https://download.drobilla.net/sratom-0.6.16.tar.xz"
  sha256 "71c157991183e53d0555393bb4271c75c9b5f5dab74a5ef22f208bb22de322c4"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?sratom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "3f9500429d1915d9fcfc47e023f383b0b9cdf4acf973a982400be49c44e6da63"
    sha256 cellar: :any, arm64_sonoma:   "e83b77c4790cd4fbb8a1f37fdb33a78c20298d89b3345559e5990f632d06f533"
    sha256 cellar: :any, arm64_ventura:  "c8ae52b2eea3191e28ec3fb96bce4b067715c0daca5e37681b368fc44350c43e"
    sha256 cellar: :any, arm64_monterey: "e9d9c40f47a753b41d128e9d061ff61f39b84483df9f67c6b7d5ca04318b55f3"
    sha256 cellar: :any, sonoma:         "920202525fe2153f008e5dacf59d6fda97ae33b127e4fa363735c1a7cd4d1598"
    sha256 cellar: :any, ventura:        "67e160e20bbf18673f2a1a91697a405478310cadf43413989dcb35a7a06ac4cf"
    sha256 cellar: :any, monterey:       "8d55f793f9a463ac0d7ce4a2e6537f10303b37bc1b8192ff3906bb07987cc670"
    sha256               x86_64_linux:   "e108a73b3a47181df80686a66bcdfb8fdbbcbb9682aeefc7a5b058699356b395"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"

  def install
    system "meson", "setup", "build", "-Dtests=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <sratom/sratom.h>

      int main()
      {
        return 0;
      }
    EOS

    pkg_config_cflags = shell_output("pkg-config --cflags --libs sratom-0").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end
