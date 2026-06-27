class RabbitmqC < Formula
  desc "C AMQP client library for RabbitMQ"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "1298b89a78bb8bc70862f612da6eb3a71ade16b5c3f2fa50ec6e5251803ed08a"
  license "MIT"
  head "https://github.com/alanxz/rabbitmq-c.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5c0be0c7f0c32a997540d9fea3ad9abc3f165173e55c2f28ab8e32f7df1f2bae"
    sha256 cellar: :any, arm64_sequoia: "8feced1bbd8e432d9fdf5fc093ea2cdf42bedb71104a31ac7ce4f6f2da3c5070"
    sha256 cellar: :any, arm64_sonoma:  "303666d09296a66e58ab617a6e64b68cd7275b41b4e870df93d32c7a162d0ee3"
    sha256 cellar: :any, sonoma:        "4298894039a8b0dcfd46465b102a1630a5fa6dd53763b7a58d2435455b69be33"
    sha256 cellar: :any, arm64_linux:   "6f2ce71175f5670a347d73501a7cbe7544357c1ca4d6920a50175ab8688649b1"
    sha256 cellar: :any, x86_64_linux:  "e0c142450012adb0b911ee96e2ff1ed8ce528e0ec29e99b7fd3583c6bc16177e"
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
