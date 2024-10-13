class RabbitmqC < Formula
  desc "C AMQP client library for RabbitMQ"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "839b28eae20075ac58f45925fe991d16a3138cbde015db0ee11df1acb1c493df"
  license "MIT"
  head "https://github.com/alanxz/rabbitmq-c.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a09697914ee9b96a53254853a46b8a33777dfbe261c0b44274f413b73d19418b"
    sha256 cellar: :any,                 arm64_sonoma:   "481a888cba8fb170eea70b89d74a7bae8050c5c8b9f121a705800ebb2c29fa0e"
    sha256 cellar: :any,                 arm64_ventura:  "97d849fd35c24416bb716a4dc050f7d5c1c8e6833d4fe07eaeb48bf11a4da147"
    sha256 cellar: :any,                 arm64_monterey: "a0368ea643e9e9ec957956b765e03576b6882ff83bab336957f9717f8da0feee"
    sha256 cellar: :any,                 sonoma:         "7bd6bcf176b849687b022b64bc7545632616ae042a073163e39c65ca4ee23fe3"
    sha256 cellar: :any,                 ventura:        "4a5fc38b266a3ddff056d073e9509d6455ad5e666baacbfe4404c3efc1fce64a"
    sha256 cellar: :any,                 monterey:       "2ce40d80d68812ba8dbda968763915567c956fab3df72707f2d283973f155626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce3a1639fb627c61efe13e6755362cbd929000026b5622d2bd1f2f1440feb590"
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
