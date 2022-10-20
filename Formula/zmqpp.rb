class Zmqpp < Formula
  desc "High-level C++ binding for zeromq"
  homepage "https://zeromq.github.io/zmqpp/"
  url "https://github.com/zeromq/zmqpp/archive/4.2.0.tar.gz"
  sha256 "c1d4587df3562f73849d9e5f8c932ca7dcfc7d8bec31f62d7f35073ef81f4d29"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ce6be56e7c768bc4c35b43d78a7938b5bf415293ce42e47230a47dc17d05e091"
    sha256 cellar: :any,                 arm64_big_sur:  "8784a9ab7929336cc1677315a134b8d379491e9980f1e2fc0c705bb0adf7c904"
    sha256 cellar: :any,                 monterey:       "7b68028743e0b92d94b1eb8a486901944d5bb77d1fb1e49b76bcfabea4f86caa"
    sha256 cellar: :any,                 big_sur:        "f85d36f077eab8c580e4e22411a9c2d89bff47a14f6b53c42eb6544c4e4250e6"
    sha256 cellar: :any,                 catalina:       "6ff257636778c3cb51a42ec7fd41d701ebb311dcbdca7fb0e63772078b59123c"
    sha256 cellar: :any,                 mojave:         "dd783ca2b0f191c1a78c60f2c13489fef5d743c8720ed26d5cda6bd8bea32ce9"
    sha256 cellar: :any,                 high_sierra:    "02c8a7e0124d22e2c9fde2349179d9340e17203ad252ed9fd56fd6c9ea71a24c"
    sha256 cellar: :any,                 sierra:         "a1843b77cb53950bcf0b29589071025a48d86f0ecb4420280f7fcff7420f1905"
    sha256 cellar: :any,                 el_capitan:     "58f0301f03f30b314cb31dbbbc9a82163930b5b00a7285e3d279f49c0e1a25d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18d5c7351051f713c13173e058151ea828788e3851c761d04c4c1d1a1d384f08"
  end

  depends_on "doxygen" => :build
  depends_on "zeromq"

  def install
    ENV.cxx11

    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    system "doxygen"
    (doc/"html").install Dir["docs/html/*.html"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <zmqpp/zmqpp.hpp>
      int main() {
        zmqpp::frame frame;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lzmqpp", "-o", "test", "-std=c++11"
    system "./test"
  end
end
