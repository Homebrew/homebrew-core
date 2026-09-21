class RabbitmqC < Formula
  desc "C AMQP client library for RabbitMQ"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "d57782c950ec04c7da3692cad6f02059dad6df90e588e2f6a1def632fa59f7d7"
  license "MIT"
  head "https://github.com/alanxz/rabbitmq-c.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "214c926e4ae437b5ded0a99051d908ae0009017753418ffd756dc6265128af66"
    sha256 cellar: :any, arm64_tahoe:       "a0684d61ad2c243af8069475dd16f1782917876b974703cbae9e20c1e72675bd"
    sha256 cellar: :any, arm64_sequoia:     "67c861cb1762c7d55eb6063b03ff299159001603f41d21d5dbddb8e4be340902"
    sha256 cellar: :any, arm64_linux:       "d7bfa7c837331e4ace2fb61a4f010da844c2919b5339ff7558757f260084d928"
    sha256 cellar: :any, x86_64_linux:      "42e48ede827ab64800b0598e87035aa0147585f84b97db21edf065a6f24dd7cb"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@3"
  depends_on "popt"

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
