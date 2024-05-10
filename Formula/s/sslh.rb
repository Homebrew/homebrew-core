class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v2.1.1.tar.gz"
  sha256 "0ad3526e072d0f0d4f77ddcdbade4bf315ebd45d468848fd3367996f414d06d7"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  head "https://github.com/yrutschle/sslh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c8d72ca1b1e20dd22dc70ea8738528ea893d857e3f3db72985eb23c0efc70275"
    sha256 cellar: :any,                 arm64_ventura:  "92d5ce443e7c6c8b506760a9f2808d9ef07d22fbb07ad085e99a60e42b4db0b8"
    sha256 cellar: :any,                 arm64_monterey: "0b2c105d59a718c0dc1a2e329bb6ef0fffda2cf877ab8131de02d4f71237f2d7"
    sha256 cellar: :any,                 sonoma:         "bfad2cadb0b0bba7f8908e8fde345cab9cac66f38864a44c21ad1b27f1af87b3"
    sha256 cellar: :any,                 ventura:        "7d280d5a6c6413b401edaaec9e9eb37bd7f18feb019df53adec00f889e93f5e1"
    sha256 cellar: :any,                 monterey:       "f3cf4d885fabf5f56faca0a5442449fe42a755d2dfd057f89a54b3878f15f46e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff0c994652a79441f11d687e0632c52d9350dd7a7fc65bf3573fdcc276bdd252"
  end

  depends_on "libconfig"
  depends_on "libev"
  depends_on "pcre2"

  uses_from_macos "netcat" => :test

  def install
    system "./configure", *std_configure_args
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
