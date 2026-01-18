class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.github.io/"
  url "https://github.com/uriparser/uriparser/releases/download/uriparser-1.0.0/uriparser-1.0.0.tar.bz2"
  sha256 "0606f62fa9522ae208173bae5258a0d3357961044417ae5ef18dad5ad26b74b1"
  license "BSD-3-Clause"
  head "https://github.com/uriparser/uriparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8123f9c6f86a2a50d9c4a1dc0372b1dbda58dca00ffc548120913bca82b1b12"
    sha256 cellar: :any,                 arm64_sequoia: "e1531dd70314ab782a8802a10f41fb12a92c684f1dca911350c3515aa633cb2a"
    sha256 cellar: :any,                 arm64_sonoma:  "40d71819f77890774f7824975233a03cf097bd063638ce35661c0237d4b6a334"
    sha256 cellar: :any,                 sonoma:        "9ad33027ee5077ec86549cc4d89d722d17c7dbd65c8268b2562603d82d2ee044"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40539ae75220b3e49800f31fb0dee16c90043170217c951f58921b511d6cf797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e09dc6060f30596da4510db32708f25e2f356ce740a7dbeef480ebac5a79eddb"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DURIPARSER_BUILD_TESTS=OFF
      -DURIPARSER_BUILD_DOCS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
