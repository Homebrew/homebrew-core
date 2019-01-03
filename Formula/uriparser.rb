class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.github.io/"
  url "https://github.com/uriparser/uriparser/releases/download/uriparser-0.9.1/uriparser-0.9.1.tar.bz2"
  sha256 "75248f3de3b7b13c8c9735ff7b86ebe72cbb8ad043291517d7d53488e0893abe"

  bottle do
    cellar :any
    sha256 "5b210fc14a9f6c44ec5a2ac3573e041286649bc3c924c3e946aba87d66144924" => :mojave
    sha256 "bdaf6db7274169bb976e058dfc4c90e47aa5fdc3fd6c075977c63e2ccee7f348" => :high_sierra
    sha256 "4eaa86287b37a5061ae8167143476b66eb8020e2f0c7a6cbed51a8311fce4cd6" => :sierra
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
