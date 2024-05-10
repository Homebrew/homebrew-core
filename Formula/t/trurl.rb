class Trurl < Formula
  desc "Command-line tool for URL parsing and manipulation"
  homepage "https://curl.se/trurl/"
  url "https://github.com/curl/trurl/archive/refs/tags/trurl-0.12.tar.gz"
  sha256 "67a1620ebb0392a9cdd8e46bc44a14e0a5d8c1a9112859fbbb525ec919d2fa9b"
  license "curl"
  head "https://github.com/curl/trurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2415e2f8f88c59adae7c4aa77bac4fe9a715e5851f4096fe63812367cd346fa5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "514387ed6fdc290e702db81c572dfd61c691f9ad7c7dfa1f5dc65c64202d9de8"
    sha256 cellar: :any,                 arm64_monterey: "99fcdc7a5d9e58e604a1a5ef1c434708a6b8227b8f7022c29f5522efaa12ae67"
    sha256 cellar: :any_skip_relocation, sonoma:         "99c265f07780793aa801d34be5aaed4a2f6e58fac0aac081c5fc5e12fcd1174e"
    sha256 cellar: :any_skip_relocation, ventura:        "10c86617298162eedfbc5c00a16e8625848da3902cb84f659d01eaa8a331ef3b"
    sha256 cellar: :any,                 monterey:       "ecde46b16ab0ea4ff3e48df4ae18da877a413b82df245ebba0ca68b5e5d97357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8d5dc74470e93a51ea777ae0b1e9a0047aa24136ca351f7994de15791804b4c"
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
