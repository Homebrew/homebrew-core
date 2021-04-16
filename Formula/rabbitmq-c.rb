class RabbitmqC < Formula
  desc "C AMQP client library for RabbitMQ"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/v0.11.0.tar.gz"
  sha256 "437d45e0e35c18cf3e59bcfe5dfe37566547eb121e69fca64b98f5d2c1c2d424"
  license "MIT"
  head "https://github.com/alanxz/rabbitmq-c.git"

  bottle do
    sha256 arm64_big_sur: "8c99de9859b3c8fd847d02a777f9f607942742c8e8c7ab11961c9f82cdd7521c"
    sha256 big_sur:       "d8e5e9610c9209804710a07ad2accdd9e07df7c6ec0dbbc987193fb724801c0f"
    sha256 catalina:      "2f15cd210e177b5d9156d3884f2b5fe735352820cc7b900a1c9dc951f56cb8e0"
    sha256 mojave:        "ad16aaef6f362020519025f174bd72c4c74d007965209d9c89b55d0d989752cc"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "popt"

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_EXAMPLES=OFF",
                         "-DBUILD_TESTS=OFF", "-DBUILD_API_DOCS=OFF",
                         "-DBUILD_TOOLS=ON", "-DCMAKE_INSTALL_RPATH=#{opt_lib}"
    system "make", "install"
  end

  test do
    system bin/"amqp-get", "--help"
  end
end
