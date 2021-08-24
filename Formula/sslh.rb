class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v1.22.tar.gz"
  sha256 "50ea47f8a52e09855e4abcba00e2d6efa3b100faef4b7a066582dfb9bd043b6e"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  head "https://github.com/yrutschle/sslh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "4e7f76188b8a7e6e4582449b44215be2e81aeae61d0597f8a4fc5019e3e01437"
    sha256 cellar: :any,                 big_sur:       "f4bca122c45d30d12a09f10415ca2e5eee87b03a5bc20aafd213f1c3b9393402"
    sha256 cellar: :any,                 catalina:      "e9b7153fafb25bcb3d0421e82ca9c96b17b243bba5968a5b0aa3fc39089ab917"
    sha256 cellar: :any,                 mojave:        "070dc0b0522e6ceb8a76af229c64d2d00b658277b8aab039d74d2e665673b02a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9fff717bea206d940cb6639ad7ea1b0d96ff06b17b3ba07925434a3fb7ceaba"
  end

  depends_on "libconfig"
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
