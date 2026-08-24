class RabbitmqC < Formula
  desc "C AMQP client library for RabbitMQ"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "66c36901178c872565f732468e91688f6280c18810fe8b21a199d46347ba3a0c"
  license "MIT"
  head "https://github.com/alanxz/rabbitmq-c.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "44fc7761fcdaed42a0668de13a55621341833aaacdbe1605df58cf5d5d4dd054"
    sha256 cellar: :any, arm64_sequoia: "3cf454e0d71a3b55b328c0aa33e676ca9ec4defb161597b2c681b4deb771ea28"
    sha256 cellar: :any, arm64_sonoma:  "f78a6b53b7324add7d03f45bee0b7a503d987f025bdf10d0746e778d60bdb1d1"
    sha256 cellar: :any, sonoma:        "0ecbf0b9243e82265d74dde8ea69dc6750891d0e7782da095f67c5a2d3e0b8a0"
    sha256 cellar: :any, arm64_linux:   "dd17f675e29bf4e812726a4af821177778f895d6feeb9184027f1e8ea0626ad8"
    sha256 cellar: :any, x86_64_linux:  "758d989dab76286324682004d3200461ce7439eb5dff4af14c2423449b2a9a6b"
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
