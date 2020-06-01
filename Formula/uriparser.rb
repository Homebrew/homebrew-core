class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.github.io/"
  url "https://github.com/uriparser/uriparser/releases/download/uriparser-0.9.4/uriparser-0.9.4.tar.bz2"
  sha256 "b7cdabe5611408fc2c3a10f8beecb881a0c7e93ff669c578cd9e3e6d64b8f87b"
  head "https://github.com/uriparser/uriparser.git"

  bottle do
    cellar :any
    sha256 "421b45811861a0ce226e7f4c9647a8b7753d9e7f84b5c84ed6b637f8839d461d" => :catalina
    sha256 "e54bac5e1cf6a1ed3f87e42f56f0ff2f4602e22cf6113bc03d82a6ae12b13f76" => :mojave
    sha256 "27649c5b2c692596c9811ab872b1b82e09ccb67dbff0a048de7137134aff81e8" => :high_sierra
    sha256 "a3ee937d18ead7330f7cf6dfbf5a63ac41dbb5e9d7e68450e3b07ff54c75d80f" => :sierra
  end

  depends_on "cmake" => :build

  conflicts_with "libkml", :because => "both install `liburiparser.dylib`"

  def install
    system "cmake", ".", "-DURIPARSER_BUILD_TESTS=OFF", "-DURIPARSER_BUILD_DOCS=OFF", *std_cmake_args
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
