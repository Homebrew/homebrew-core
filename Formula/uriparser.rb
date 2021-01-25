class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.github.io/"
  url "https://github.com/uriparser/uriparser/releases/download/uriparser-0.9.4/uriparser-0.9.4.tar.bz2"
  sha256 "b7cdabe5611408fc2c3a10f8beecb881a0c7e93ff669c578cd9e3e6d64b8f87b"
  head "https://github.com/uriparser/uriparser.git"

  bottle do
    cellar :any
    sha256 "76fb92889b92e80282a0794e814c21d403bda66dd70dffaca61142bfb02a1ccd" => :big_sur
    sha256 "0fac36c34a537dd29050a29003d5e4a1c34ce8d00d964c7e8ebdeaafa99f6268" => :catalina
    sha256 "5440ffb9d3363007478193e0ed4653d8f5eaf27fd36b5c0968968b73d14af2f9" => :mojave
    sha256 "b25005697a3acc8cd6921189f41e6f7fa1c6667a9e259a3d85f8f1dea6915460" => :high_sierra
  end

  depends_on "cmake" => :build

  conflicts_with "libkml", because: "both install `liburiparser.dylib`"

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
