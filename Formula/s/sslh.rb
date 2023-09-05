class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v2.0.0.tar.gz"
  sha256 "5231dd575885024ed4b8217fdc6105d27b5780a538be4bee999610837ee71eb1"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  head "https://github.com/yrutschle/sslh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e46cf7a86fadc579eaac97b9092c3bcda307b4f217e62efed9e11ce2b6a96114"
    sha256 cellar: :any,                 arm64_monterey: "bb9e8015f0f0b91eeda6fcba621a09f8e73af0fc2821bdcdf9ba95a3f54bb86a"
    sha256 cellar: :any,                 arm64_big_sur:  "b9a51df44dad81d17bbf8139d29ed1afe0c0d672b8c31ee0b45b51b252e6c111"
    sha256 cellar: :any,                 ventura:        "f628b7a35c410244ddb20de437614feaf530f632f54b345cfdb036b67bb764cc"
    sha256 cellar: :any,                 monterey:       "1b91815e5bc6a322f1fd78c76f5b3409be8cbc8dbd3cdf3b9bfc3e7c6153e3c6"
    sha256 cellar: :any,                 big_sur:        "3bfe89196ee7a9cb80a630527e3317264fcbc1a00bd6126bc447c0fb03f9a812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2372eff0ce1ee5bc4f3bee1d3a29cd693ed63423f4d5d77ac1e1e9db8b6309d1"
  end

  depends_on "libconfig"
  depends_on "libev"
  depends_on "pcre2"

  uses_from_macos "netcat" => :test

  def install
    ENV.deparallelize
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    listen_port = free_port
    target_port = free_port

    fork do
      exec sbin/"sslh", "--http=localhost:#{target_port}", "--listen=localhost:#{listen_port}", "--foreground"
    end

    sleep 1
    system "nc", "-z", "localhost", listen_port
  end
end
