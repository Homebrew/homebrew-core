class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v2.0.1.tar.gz"
  sha256 "d88d43ee11cf1324983c196c894b41766c33d957b6af53b62c8479703bbbd26c"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  head "https://github.com/yrutschle/sslh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2d5b73cb66f5292e81fa29e4417a6efa9237add2c5cded74a52413342fe74cf7"
    sha256 cellar: :any,                 arm64_monterey: "4f6e960fe14a33d9c3dbdb211005e83e031b45181c4a86eb2beee19f85ddee49"
    sha256 cellar: :any,                 arm64_big_sur:  "d52b4cd23321a212cff13c1d2ae96abc21ba337ad257ba0d11a1000900779c20"
    sha256 cellar: :any,                 ventura:        "90cb9bedb2b68eecc669cc7a632554b3dc0b26a3707d6f1e87d802675a34571e"
    sha256 cellar: :any,                 monterey:       "c6dbbad333b8773de67bdf306600a7b2e6c74ac9952079593d7da006251a92bc"
    sha256 cellar: :any,                 big_sur:        "28a9be93000bee82a73476d5776321dbfe76581cd642cbb86b4cd79c2d9ce237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b2a4381ff16b4bca02afc8f101331e3f5722ab997afe6af354e0653ee558d33"
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
