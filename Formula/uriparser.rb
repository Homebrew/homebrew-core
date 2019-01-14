class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.github.io/"
  url "https://github.com/uriparser/uriparser/releases/download/uriparser-0.9.1/uriparser-0.9.1.tar.bz2"
  sha256 "75248f3de3b7b13c8c9735ff7b86ebe72cbb8ad043291517d7d53488e0893abe"

  bottle do
    cellar :any
    sha256 "69c5e0b1aad68761b9737618740c57339c06fa5b33ca42f8739af1e795cc6645" => :mojave
    sha256 "aecf626254251f0f3eecca369bf8cda28f530a14bdf2bb493063a8eb78b402bc" => :high_sierra
    sha256 "0657e76e94b481bc0b859ba68b8e31d460dce44e7ec3fcc573cb5bfd6bb89839" => :sierra
  end

  head do
    url "https://github.com/uriparser/uriparser.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  conflicts_with "libkml", :because => "both install `liburiparser.dylib`"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.1.tar.gz"
    sha256 "9bf1fe5182a604b4135edc1a425ae356c9ad15e9b23f9f12a02e80184c3a249c"
  end

  def install
    (buildpath/"gtest").install resource("gtest")
    (buildpath/"gtest/googletest").cd do
      system "cmake", "."
      system "make"
    end
    ENV["GTEST_CFLAGS"] = "-I./gtest/googletest/include"
    ENV["GTEST_LIBS"] = "-L./gtest/googletest/ -lgtest"
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
