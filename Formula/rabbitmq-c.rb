class RabbitmqC < Formula
  desc "C AMQP client library for RabbitMQ"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/v0.12.0.tar.gz"
  sha256 "ded0f5088450bc52f288e23f01e5dfc52ea812c020d81fd124d74736da9427b3"
  license "MIT"
  head "https://github.com/alanxz/rabbitmq-c.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8cd28a5c50c682592c7b4965a8a3b98247dbc3cc086eb9be520ec8c4b2f573a6"
    sha256 cellar: :any,                 arm64_monterey: "f0d844e45fe322d9032baaf1f8714c9b3a9dd8a9629c78500fea5620c20c0d01"
    sha256 cellar: :any,                 arm64_big_sur:  "fab52cfefd873de24513d54662bdba8a4f6604768a629477d655e334d84ff3e8"
    sha256 cellar: :any,                 ventura:        "fdedbc0e58627dd553cdc904b1b6060989dbe003db0a38b6fa3219cfb9bf5396"
    sha256 cellar: :any,                 monterey:       "9e94d4e4635166f7a7acb74f802c650a063b5612bf0292da7449f09186f7e22b"
    sha256 cellar: :any,                 big_sur:        "9a2c1e519eafcd31eb76698ed0f8a3dc27b10afa252262ae7ea585da4cd07179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0572c7cab11aec2137e0b6409e3a8b218bffb617e2fa2d29c25c2afd906a2180"
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
