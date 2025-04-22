class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.github.io/"
  url "https://github.com/uriparser/uriparser/releases/download/uriparser-0.9.8/uriparser-0.9.8.tar.bz2"
  sha256 "72d1b559be3a1806f788a3d9be34a1b063d42aa238b29ba4ee633d6effcd33bd"
  license "BSD-3-Clause"
  head "https://github.com/uriparser/uriparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "7cee35b2ea5693567cabf7ef30e9a6c8f35423ccad4cba6fa4f9dff90727d79e"
    sha256 cellar: :any,                 arm64_sonoma:   "1afad33dd8c8d67dd454030f96ca7b71fd625b088ba4e7354f52eb789995d2af"
    sha256 cellar: :any,                 arm64_ventura:  "71f1d1f2919cd33409df57ff9464007a85aaf5ed23b496b1fc3311be22edb07e"
    sha256 cellar: :any,                 arm64_monterey: "0f9231a7cc6bd6bf5578ec959b4951a9fa2bdf22a9f1ed571c5f3d9c2eccdc65"
    sha256 cellar: :any,                 sonoma:         "9f1884bfa5687f65eca6be5aec1e0c5618f5faa404290d0827bb3c390828fcee"
    sha256 cellar: :any,                 ventura:        "8df3c1c481bb8dca64b708dd35cc514e3743827b4d6b544aa5418d4ed90e868e"
    sha256 cellar: :any,                 monterey:       "942834f010ac0ac2d508277f6f4c8d00d229654bf02de7528df7d53d5ca72771"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "93dc11e4bc86e1a410469220e448cbef25afb05dddc71ab5aed53ebcf818fcb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "690d05924e1dcfe664e3e0891326fa6c19aa61c178d1cff63a361013cad4b001"
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
