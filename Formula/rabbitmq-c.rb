class RabbitmqC < Formula
  desc "RabbitMQ C client"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/v0.9.0.tar.gz"
  sha256 "316c0d156452b488124806911a62e0c2aa8a546d38fc8324719cd29aaa493024"
  revision 1
  head "https://github.com/alanxz/rabbitmq-c.git"

  bottle do
    cellar :any
    sha256 "93a530bf4844d0d3c653826359aa77bcb67691a0424b8ca1c6b20bec29733821" => :mojave
    sha256 "af732c62d886aa4ec4c2e73287d06e2ed422736de17637395c0a44474942fca1" => :high_sierra
    sha256 "2ed895d32e8a07f12b3583541f9fc8d59935e5aa767797f56711e67cdcfbd889" => :sierra
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
