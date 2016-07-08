class RabbitmqC < Formula
  desc "RabbitMQ C client"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/v0.8.0.tar.gz"
  sha256 "d8ed9dcb49903d83d79d7b227da35ef68c60e5e0b08d0fc1fb4e4dc577b8802b"
  head "https://github.com/alanxz/rabbitmq-c.git"

  bottle do
    cellar :any
    sha256 "eb9a25f5371072c0f4833c7f4554f2b5e53b7e2b5ea10e33230cad8b6c9affe4" => :el_capitan
    sha256 "c0775f463db385d302b4d73d6403842ce16654c2f7a2618e6c0d1aa7c0590a14" => :yosemite
    sha256 "f4e4d641af6559ee49beec28a7620af68e643ac26429c5f031953e8d79c8b0b6" => :mavericks
  end

  option :universal
  option "without-tools", "Build without command-line tools"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "popt" if build.with? "tools"
  depends_on "openssl"

  def install
    ENV.universal_binary if build.universal?
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=OFF"
    args << "-DBUILD_TESTS=OFF"
    args << "-DBUILD_API_DOCS=OFF"

    if build.with? "tools"
      args << "-DBUILD_TOOLS=ON"
    else
      args << "-DBUILD_TOOLS=OFF"
    end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system bin/"amqp-get", "--help"
  end
end
