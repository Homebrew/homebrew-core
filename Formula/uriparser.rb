class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.github.io/"
  url "https://github.com/uriparser/uriparser/releases/download/uriparser-0.9.7/uriparser-0.9.7.tar.bz2"
  sha256 "d27dea0c8b6f6fb9798f07caedef1cd96a6e3fc5c6189596774e19afa7ddded7"
  license "BSD-3-Clause"
  head "https://github.com/uriparser/uriparser.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "8ed697813938a18193dfd1a3a048cf3b237429ae6dadabc943cd419c2e948dde"
    sha256 cellar: :any,                 arm64_big_sur:  "c6e0c16982bf15a531e8e2d60abb7d104407b0b7e01aac9b59e817cf1890bfba"
    sha256 cellar: :any,                 monterey:       "687b043d447e68967f63077a08053b18fd9791f33645781ffb17eae9c7bde984"
    sha256 cellar: :any,                 big_sur:        "f34888412c2e45eeb6e3cccb5a6d73064c2e8f52a000790828d907d63a48a90a"
    sha256 cellar: :any,                 catalina:       "646001e197cd645dbf99ed8036d21289056bca546dcfab074e7031af5c7cc4db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fa1c9ef128411497b8e7ac7689cfb730571281c6ac071173ef961383ed6dd4f"
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
