class Trurl < Formula
  desc "Command-line tool for URL parsing and manipulation"
  homepage "https://curl.se/trurl/"
  url "https://github.com/curl/trurl/archive/refs/tags/trurl-0.10.tar.gz"
  sha256 "e54ee05a1a39f2547fbb39225f9cf5e2608eeaf07ad3f7dbff0a069d060d3c46"
  license "curl"
  head "https://github.com/curl/trurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4886ffef9b94a416a41f17e4907156959712c88a09df14f1dc6a924154a49d6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a36314122612daef2bc5bb5479dbaa5aff372a984060757b6f41228025ef242"
    sha256 cellar: :any,                 arm64_monterey: "252c9e7fe7d0da6181b279758aac617e6201253fc6a8fae552ec4590a56b045a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1a2526089bb814d2604f7d1cae1914c84b3cf03b766e832e84378bb8bc0cf5b"
    sha256 cellar: :any_skip_relocation, ventura:        "8b405bf8b11782d00453f475c69f3bcb70f6467acbc6f2bd88202a3c67f2bc59"
    sha256 cellar: :any,                 monterey:       "a5c4e330963b151dbd17b8ae81700663f2703b1235a3c3debe1a8338a6fd9b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fec75bd56c994820629b18df12c09f8fc0af6fbcaf8906649b2a7900dd4e562c"
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
