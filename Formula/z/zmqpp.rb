class Zmqpp < Formula
  desc "High-level C++ binding for zeromq"
  homepage "https://zeromq.github.io/zmqpp/"
  url "https://github.com/zeromq/zmqpp/archive/refs/tags/4.2.0.tar.gz"
  sha256 "c1d4587df3562f73849d9e5f8c932ca7dcfc7d8bec31f62d7f35073ef81f4d29"
  license "MPL-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "39907cc6b73b2e45317f6a339f58914602cd3a42b36f601252e440ab4106f4e8"
    sha256 cellar: :any,                 arm64_sequoia:  "9fa8e84d3f7cdd481639d63079b3ff25804d464cdf1107397bcde6fe4950726a"
    sha256 cellar: :any,                 arm64_sonoma:   "574b288b419ea2c184b6720d566a15dd75554bc252379a86cefc173794866a7d"
    sha256 cellar: :any,                 arm64_ventura:  "79259180cd88ddb59497fbb3075a02c19ac854e5a57f1ff33f53c328789b4dd5"
    sha256 cellar: :any,                 arm64_monterey: "ce6be56e7c768bc4c35b43d78a7938b5bf415293ce42e47230a47dc17d05e091"
    sha256 cellar: :any,                 arm64_big_sur:  "8784a9ab7929336cc1677315a134b8d379491e9980f1e2fc0c705bb0adf7c904"
    sha256 cellar: :any,                 sonoma:         "11a46057f1f31e68d13696542b6fa161601f531e06fadde4e246991c425834d1"
    sha256 cellar: :any,                 ventura:        "13235aadbe1f01545aa68211914aca2ee5c209121db4eb1964129476b515eb80"
    sha256 cellar: :any,                 monterey:       "7b68028743e0b92d94b1eb8a486901944d5bb77d1fb1e49b76bcfabea4f86caa"
    sha256 cellar: :any,                 big_sur:        "f85d36f077eab8c580e4e22411a9c2d89bff47a14f6b53c42eb6544c4e4250e6"
    sha256 cellar: :any,                 catalina:       "6ff257636778c3cb51a42ec7fd41d701ebb311dcbdca7fb0e63772078b59123c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "93f20e52dd105b35681cb16f0a68b3df968a80b03b87f9ea707e7fcd18ea0578"
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
    (testpath/"test.cpp").write <<~CPP
      #include <zmqpp/zmqpp.hpp>
      int main() {
        zmqpp::frame frame;
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lzmqpp", "-o", "test", "-std=c++11"
    system "./test"
  end
end
