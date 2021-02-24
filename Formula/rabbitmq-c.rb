class RabbitmqC < Formula
  desc "C AMQP client library for RabbitMQ"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/v0.10.0.tar.gz"
  sha256 "6455efbaebad8891c59f274a852b75b5cc51f4d669dfc78d2ae7e6cc97fcd8c0"
  license "MIT"
  head "https://github.com/alanxz/rabbitmq-c.git"

  bottle do
    sha256 cellar: :any, big_sur:     "f76f526ae3c37b8f686cbd796d2fc9f1ec6210e0ae2f8986260efa834b99c9f3"
    sha256 cellar: :any, catalina:    "6434a9100eeadfcd57d35fd31d1863d75b71ec163a3a1be29076c217712bda55"
    sha256 cellar: :any, mojave:      "5f99c633ece8efad2ef2085955b22d0558d8fc2dedcac67b3ba8b58a2640c2c3"
    sha256 cellar: :any, high_sierra: "53d883744a185e5daab18c8bd18fd70fed56dd009cc507356f128663947c2453"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "popt"

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_EXAMPLES=OFF",
                         "-DBUILD_TESTS=OFF", "-DBUILD_API_DOCS=OFF",
                         "-DBUILD_TOOLS=ON"
    system "make", "install"
  end

  test do
    system bin/"amqp-get", "--help"
  end
end
