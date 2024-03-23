class RabbitmqC < Formula
  desc "C AMQP client library for RabbitMQ"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "839b28eae20075ac58f45925fe991d16a3138cbde015db0ee11df1acb1c493df"
  license "MIT"
  head "https://github.com/alanxz/rabbitmq-c.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "53cde184b98e59c3cd3590e2e2702642a79162123ca6917adcf465226e436c9c"
    sha256 cellar: :any,                 arm64_ventura:  "8300b853149a48fbb994fdffb450c5f5974fd00a0647fa67bf19160a6e5ad7ca"
    sha256 cellar: :any,                 arm64_monterey: "a535aabd5105785be102958d8da641d813b55d5f292d175384568620878e108c"
    sha256 cellar: :any,                 arm64_big_sur:  "bafb8c371b69f5b96aa9f0003476dc9bd2fe2fb68f5e1b1cab3f5e01c4118b3e"
    sha256 cellar: :any,                 sonoma:         "ba02aa32c5381b28dcd896a6b699a8d20746549aa1a25d5a5c8311d085f5741c"
    sha256 cellar: :any,                 ventura:        "3f58f1815e7a926299b7b8ee63fbc4aaa5168b62fd23b6ca6a839434cf58829d"
    sha256 cellar: :any,                 monterey:       "d49bda436f08ed872162c74ad3c13e075ff875758b96193be83aae653c34cc58"
    sha256 cellar: :any,                 big_sur:        "f0dd379776596b3016bceccb8290e0f5476fc36a652a9888c2179f8f6a362250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5ab7a9538bdba41d37c84fc7c0647a73815776cd7905c7a0a2b28e4a830c1bc"
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
