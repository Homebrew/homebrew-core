class RabbitmqC < Formula
  desc "C AMQP client library for RabbitMQ"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/v0.11.0.tar.gz"
  sha256 "437d45e0e35c18cf3e59bcfe5dfe37566547eb121e69fca64b98f5d2c1c2d424"
  license "MIT"
  head "https://github.com/alanxz/rabbitmq-c.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "683a44cba4e1e063e150bbcf602ea5c8a310b12d88faf0c98b8ca2673f0c7699"
    sha256 cellar: :any,                 arm64_monterey: "b5e656e15711c417775fb532b61374f34fb00b69ddf2f24841d6c8976bb1c29c"
    sha256 cellar: :any,                 arm64_big_sur:  "5356ca6f455bb61d4ab4d8d66a27d399ebd027bddd5ebfe9bc5daa69d97c1dda"
    sha256 cellar: :any,                 ventura:        "5e79508f8c8f343e672a05051977de2aeaaccf72c6684a4eec96f9fba1f8d99a"
    sha256 cellar: :any,                 monterey:       "9528f0000e5d9beb29ca43cf88d0e04f92e05c1361bf1edbeb87212b68b8b295"
    sha256 cellar: :any,                 big_sur:        "5f060aea640ac85272c2a4c2b4f5e0ced90d38942bded0c841b9f75c2cbcdf75"
    sha256 cellar: :any,                 catalina:       "8f68d7d99f11f8443466b47289ea01700467e1786ee6ba0cd02ab98046787186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88e01cadd8c92b6afcf52fcbbe435ba1103320d3e5d4172e1db15f355116daa2"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
