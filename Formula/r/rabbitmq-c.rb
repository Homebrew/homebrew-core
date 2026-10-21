class RabbitmqC < Formula
  desc "C AMQP client library for RabbitMQ"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "0779bd4f00175ff2f722f9dc43b542bea3bc606ed079e7099fa8a18627c2ddc9"
  license "MIT"
  head "https://github.com/alanxz/rabbitmq-c.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0dae886d1dcdb87c121a9418521e3f876c8a47a3b813df14de62410ecfd44237"
    sha256 cellar: :any, arm64_tahoe:       "71a0c2d2f3b8345971bdac35f5ff640d55bca66b6ba8ba2236623dc58e648b1d"
    sha256 cellar: :any, arm64_sequoia:     "2d24f97e779ca7e0d301a3c328f25ea7298f3623355208d744fb5f93d2b36aee"
    sha256 cellar: :any, arm64_linux:       "4a913012f58d5ce947c855d38770ef6c44740633ea4ad0f876e838cfb9589042"
    sha256 cellar: :any, x86_64_linux:      "3a8494afac1d8ae09ff91899e3e83ca14b02e215cba840f5d97ba638e8198285"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@4"
  depends_on "popt"

  deny_network_access!

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
