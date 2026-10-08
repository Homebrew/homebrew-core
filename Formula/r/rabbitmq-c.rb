class RabbitmqC < Formula
  desc "C AMQP client library for RabbitMQ"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "d57782c950ec04c7da3692cad6f02059dad6df90e588e2f6a1def632fa59f7d7"
  license "MIT"
  revision 1
  head "https://github.com/alanxz/rabbitmq-c.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9186266481f6b10609cdaefcc08cb6aaf4eafde487e8716a7d90b44ed2e70a5f"
    sha256 cellar: :any, arm64_tahoe:       "7d415c7d30bd5f9a15eb68f2b66b7cec3d576811419993e9b76300d5bf8a28f6"
    sha256 cellar: :any, arm64_sequoia:     "e93b67824e0b33f95cecce8990b1d07487c9bb230c41ab1500c0cd971bfa07e4"
    sha256 cellar: :any, arm64_linux:       "866f2384f1f73def468253b3031610c39764462f37dabdaf6e8b58bf1cc6981d"
    sha256 cellar: :any, x86_64_linux:      "3c7500a73280d34ca8c2e33aa8d55793e55f187fad867ff92418152b71ed6032"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@4"
  depends_on "popt"

  deny_network_access!

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_API_DOCS=OFF",
                    "-DBUILD_EXAMPLES=OFF",
                    "-DBUILD_TESTS=OFF",
                    "-DBUILD_TOOLS=ON",
                    "-DBUILD_TOOLS_DOCS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"amqp-get", "--help"
  end
end
