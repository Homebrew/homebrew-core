class Trurl < Formula
  desc "Command-line tool for URL parsing and manipulation"
  homepage "https://curl.se/trurl/"
  url "https://github.com/curl/trurl/archive/refs/tags/trurl-0.7.tar.gz"
  sha256 "11616a4c3d255ff3347cb8fc65ea4f890526f327800ec556d78e88881e2cbfa7"
  license "curl"
  head "https://github.com/curl/trurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ce938255fb3b504920158bfcf1a2b7f5b6ee1a79b7f3dd47f8f86ce6f1c776d"
    sha256 cellar: :any,                 arm64_monterey: "2552ab4fd11596b34a87c6124651caa8d7f4346ed81a84d2b803000e36e5dcde"
    sha256 cellar: :any,                 arm64_big_sur:  "7228cb4d30d02e8940ba166d914d1b6723a671ebdf6dd272cc466ade5432df94"
    sha256 cellar: :any_skip_relocation, ventura:        "f81b533b5f8ce588457634329a10fbb4d5265872f1108d2f2b05a15ac92ffae3"
    sha256 cellar: :any,                 monterey:       "c5123f1ac7172ec14df2d27598c9a2a30d3e01efc91db3070e19302a77ccb028"
    sha256 cellar: :any,                 big_sur:        "5d8db3f7aa5123336b4b9148afb1a33ef3fdb2400901ad7c0cd56fd7745d3363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc004c9bf10f2c056ddd92819aca4bbaf5ad4d383f888caa439727976b43db52"
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
