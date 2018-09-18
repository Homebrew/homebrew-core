class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.github.io/"
  url "https://github.com/uriparser/uriparser/releases/download/uriparser-0.8.6/uriparser-0.8.6.tar.bz2"
  sha256 "0709a7e572417db763f0356250d91686c19a64ab48e9da9f5a1e8055dc2a4a54"

  bottle do
    cellar :any
    sha256 "a2613afbad390f2280861e6d7ddeb71337a13689db42cc75d2bf79f3efb4e75d" => :mojave
    sha256 "8b2843833bbd7c3cb5ebb780fcd600b54be3c547ef03067e6a095ab772105a0c" => :high_sierra
    sha256 "00f888952c50bb33c23b95400867018e16751604f2bf6f98b57345988cb64415" => :sierra
    sha256 "baed8adf0a6359236ac8b588470f02dbf257cfefb76ba484f6133ddb97ea6f61" => :el_capitan
  end

  head do
    url "https://github.com/uriparser/uriparser.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
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
