class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.github.io/"
  url "https://github.com/uriparser/uriparser/releases/download/uriparser-0.8.5/uriparser-0.8.5.tar.bz2"
  sha256 "58eacd5c03d9e341c04eb0b30831faec89f3b415949ff8d72254e63432352cdd"

  bottle do
    cellar :any
    sha256 "8abfde79da3b47d6926720fe55ad6c0aa9da10333e129385dc1baf085ec82acb" => :high_sierra
    sha256 "adb7098ddf448c77f4a307ffd7cca24a8c9c15bb9239cd04d8501f670442f490" => :sierra
    sha256 "7ceba640674cfe1049e0a9befad30a10837f382fce85f28a4b2f22383a774cf5" => :el_capitan
  end

  head do
    url "https://github.com/uriparser/uriparser.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "cpptest"

  conflicts_with "libkml", :because => "both install `liburiparser.dylib`"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-doc"
    system "make", "check"
    system "make", "install"
  end

  test do
    expected = <<~EOS
      uri:          https://brew.sh
      scheme:       https
      hostText:     brew.sh
      absolutePath: false
                    (always false for URIs with host)
    EOS
    assert_equal expected, shell_output("#{bin}/uriparse https://brew.sh").chomp
  end
end
