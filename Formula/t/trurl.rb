class Trurl < Formula
  desc "Command-line tool for URL parsing and manipulation"
  homepage "https://curl.se/trurl/"
  url "https://github.com/curl/trurl/archive/refs/tags/trurl-0.8.tar.gz"
  sha256 "7baccde1620062cf8c670121125480269b41bdc81bd4015b7aabe33debb022c6"
  license "curl"
  head "https://github.com/curl/trurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5b8f4f64143dde416e56f23b4457a503f626dc7debbd6f9de72082c645ede4b"
    sha256 cellar: :any,                 arm64_monterey: "a723fa5853378509b04ae2d731d121ebac0165188ad1b05e11c8641a051aa78b"
    sha256 cellar: :any,                 arm64_big_sur:  "1d858b704c8dd22820c2b067c6845075d0c25c12053a8512514e04f7a90e4ed2"
    sha256 cellar: :any_skip_relocation, ventura:        "c73dec1c919874c01b4fc7de405d6e0ff9977d27fe27208f8a74888905717813"
    sha256 cellar: :any,                 monterey:       "01b3a92be04c378ca91e2af21b57ff4a566c73a6063b39484246931024d54544"
    sha256 cellar: :any,                 big_sur:        "3a52f96f3a26f0fa142d51a6a4846eaf4576c08662078806e41b8dcb185ca076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9789427f3efa65ee8794685624d56839e7c1602690fd19dbc1d4295e795806d3"
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
