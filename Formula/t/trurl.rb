class Trurl < Formula
  desc "Command-line tool for URL parsing and manipulation"
  homepage "https://curl.se/trurl/"
  url "https://github.com/curl/trurl/archive/refs/tags/trurl-0.14.tar.gz"
  sha256 "5080ce71984fc620c1d12010c70c22e8020aeeba7009afcdfce7a9ea40caa4d2"
  license "curl"
  head "https://github.com/curl/trurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e23afef7665c53e5fed0affa118e5009a6b37ba059b4c12f22161b429e5deaf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b10b1b49a4f868f3356c1125dca0f7d368edbef6643fd050f7280956b8ab0bd"
    sha256 cellar: :any,                 arm64_monterey: "6156f1e9a574b88d5d407515b73ad7ce55bb72ddcb4794fbd4a71c2bd1a2c6af"
    sha256 cellar: :any_skip_relocation, sonoma:         "1dac5abe903414105fa95488bb0622a301c06a0cae4481f80292e6f63d9bb60c"
    sha256 cellar: :any_skip_relocation, ventura:        "ccc5315514c0f435bfe8daf554c8910545242ea1f2ecf3c3bf17e2420d46f938"
    sha256 cellar: :any,                 monterey:       "214d6b31f9e82729b40e8c81e858338a9818ed51d922ac713090dee4b0d0f340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd9ae2b79ab4657fe1b27e43bf37c42bd27b0d2ea84df44ede3c6d7fdab68003"
  end

  uses_from_macos "curl", since: :ventura # uses CURLUE_NO_ZONEID, available since curl 7.81.0

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output(bin/"trurl https://example.com/hello.html " \
                              "--default-port --get '{scheme} {port} {path}'").chomp
    assert_equal "https 443 /hello.html", output
  end
end
