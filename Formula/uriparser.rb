class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.github.io/"
  url "https://github.com/uriparser/uriparser/releases/download/uriparser-0.9.5/uriparser-0.9.5.tar.bz2"
  sha256 "dd8061eba7f2e66c151722e6db0b27c972baa6215cf16f135dbe0f0a4bc6606c"
  license "BSD-3-Clause"
  head "https://github.com/uriparser/uriparser.git"

  bottle do
    sha256 arm64_big_sur: "a232c7c90f40e4d6bfe8b3c40a95ae3e1a94d6708aa760069e4b1342e2a381ea"
    sha256 big_sur:       "767b99054e0df214d405118c1e89f8389160796417dfb4e8c90ea0201bb8c05a"
    sha256 catalina:      "cbe548d6a30819a907fc66b3de6ef90e8329e6c7a000a72bf392c7ca127817f8"
    sha256 mojave:        "9a8730ce5324d0e846cb7176b04856efadf5ba490638834a9a46502fc0dba715"
  end

  depends_on "cmake" => :build

  conflicts_with "libkml", because: "both install `liburiparser.dylib`"

  def install
    system "cmake", ".", "-DURIPARSER_BUILD_TESTS=OFF",
                         "-DURIPARSER_BUILD_DOCS=OFF",
                         "-DCMAKE_INSTALL_RPATH=#{rpath}",
                         *std_cmake_args
    system "make"
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
