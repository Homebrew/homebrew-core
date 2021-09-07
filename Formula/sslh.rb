class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v1.22c.tar.gz"
  sha256 "8e3742d14edf4119350cfdc7bb96b89134d9218eb6d2a6e1f70891ca18a649b1"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  head "https://github.com/yrutschle/sslh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8360d538e98fcd95eb8e2cdc151631bed5b0004c8c3f57ec1b0458f0e68ccd62"
    sha256 cellar: :any,                 big_sur:       "24d1ee698d3b2e8b8c88e760e9839371be04b8440ca936209a4869d01d2393a1"
    sha256 cellar: :any,                 catalina:      "64f1e1f8f49dd800b936a648a319fe85f644ce183db00032314db93e484611a0"
    sha256 cellar: :any,                 mojave:        "3b5ff13cd57fa71015eda12c607dc180d11f999c0b1b9703419c3eebc54e8087"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3d9d49219f6926130f5ca51eacd965a9e7ca88f860fa1707cec83ed1b1cb7a2"
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
