class RabbitmqC < Formula
  desc "C AMQP client library for RabbitMQ"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/v0.11.0.tar.gz"
  sha256 "437d45e0e35c18cf3e59bcfe5dfe37566547eb121e69fca64b98f5d2c1c2d424"
  license "MIT"
  head "https://github.com/alanxz/rabbitmq-c.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "5ef6efee964e2f6006a1cd1606cfc8ea9611b74d94bc3649cf701cc0cb545a18"
    sha256 cellar: :any,                 arm64_big_sur:  "d060c016414d8d55afa295308d1582fee4db9f36cc43770600fa8bc480e42511"
    sha256 cellar: :any,                 monterey:       "d6171b1b0042e0d02f941da67cb6c57ae56ea50e76b8798e5073880af7da13b6"
    sha256 cellar: :any,                 big_sur:        "efe8285e7bdfc661fa5cfede54785b44e817b38fa800e64f75dec2755ae69a7a"
    sha256 cellar: :any,                 catalina:       "1ae238a471c056d01372fed68b25dbcfe5a29a88f144b9cf09b859a4f287af98"
    sha256 cellar: :any,                 mojave:         "80ecbc2444e12039a77f178dbd7557bcda2795ea182bc7fd788f16e7f5e48e4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a34fc2c4bd5afb8f42933b4533892385aa479637101a6e48b01312830ed850ad"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "popt"

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_EXAMPLES=OFF",
                         "-DBUILD_TESTS=OFF", "-DBUILD_API_DOCS=OFF",
                         "-DBUILD_TOOLS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "make", "install"
  end

  test do
    system bin/"amqp-get", "--help"
  end
end
