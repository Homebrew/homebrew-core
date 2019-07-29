class RabbitmqC < Formula
  desc "RabbitMQ C client"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/v0.9.0.tar.gz"
  sha256 "316c0d156452b488124806911a62e0c2aa8a546d38fc8324719cd29aaa493024"
  head "https://github.com/alanxz/rabbitmq-c.git"

  bottle do
    cellar :any
    sha256 "2d3955f945f55d8627d0e7107cd5e0d64e6f67f1385f56be7c5c65e9fc15e0dc" => :mojave
    sha256 "d95c6f2c892a815ac20fe9a57fac961c73390182abb748d95d5901a3cb45d7ab" => :high_sierra
    sha256 "b2c77dd791f014dfd33983394a369f97e23e0c4519d451b552322df9dced4081" => :sierra
    sha256 "892c266e4c6086c65b3e4cee8cf5116f59d682b178540ee3f78efeff1e9d912a" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
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
