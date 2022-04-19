class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.github.io/"
  url "https://github.com/uriparser/uriparser/releases/download/uriparser-0.9.6/uriparser-0.9.6.tar.bz2"
  sha256 "9ce4c3f151e78579f23937b44abecb428126863ad02e594e115e882353de905b"
  license "BSD-3-Clause"
  head "https://github.com/uriparser/uriparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3f134b815c73529b29e59b870500d5b66f3643a3f77d26f0ae160d02114713c0"
    sha256 cellar: :any,                 arm64_big_sur:  "e873b79a8af0b5331dcd4e51af7d4f52c88e6bf638b842f89cfeafa6606a6d1e"
    sha256 cellar: :any,                 monterey:       "ed815b10b6d13b85d1dcc744bdb27c619d7cea1065e0b225587fb15f530feaf2"
    sha256 cellar: :any,                 big_sur:        "2e8ad9cd04d73bb1be69799562415023d2d5b3010e0cf1a5d3196ca5695912f8"
    sha256 cellar: :any,                 catalina:       "e57fd509a1cf3725b9b95cdc75e387702d876065975e1401f83a634e442a7f92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95d5ad1a9ad35dd79d6c7215349715c2f9f53ae1eec02d38506973a92d0706cc"
  end

  depends_on "cmake" => :build

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
