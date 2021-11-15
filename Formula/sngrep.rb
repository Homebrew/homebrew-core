class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.4.9.tar.gz"
  sha256 "3c6f28b5c795a5b1844a8997aa430aba72e083c8bd52939990900450c5f4c85a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "328666d36c468478d3c63ee9187b57dec4d8fd58a0554296c917f77062eb7a71"
    sha256 cellar: :any,                 arm64_big_sur:  "449af17f3cb8673ec2beb158ba5a48bfc620739bac89bce15eeaea4297c65972"
    sha256                               monterey:       "caf2d4342c7cb6bacdbe8e7fb2187f263db2454e626df689090db07fb44cbd73"
    sha256                               big_sur:        "d226ad4dbc036097beeefdb5d181954c3ed8eaeef9d236189598783d03a6a4c3"
    sha256                               catalina:       "95e8048031ea84674d2147c224aae73c14616164c74234f25d3001e15b779a35"
    sha256                               mojave:         "20e51aa586d1a16ad0ed97aacc941649b8872a78e36f3ec34dbdb8ea2a674216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ce3e5f4cb6aded2538bef214778a5b4204b460421ec57f6314685e4a90085b9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl@1.1"

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  def install
    ENV.append_to_cflags "-I#{Formula["ncurses"].opt_include}/ncursesw" if OS.linux?

    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system bin/"sngrep", "-NI", test_fixtures("test.pcap")
  end
end
