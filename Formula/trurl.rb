class Trurl < Formula
  desc "Command-line tool for URL parsing and manipulation"
  homepage "https://curl.se/trurl/"
  url "https://github.com/curl/trurl/archive/refs/tags/trurl-0.5.tar.gz"
  sha256 "b5c5600cd3533e208b720f13aa06de724270d1750406b41a22f48ce95c51844d"
  license "curl"
  head "https://github.com/curl/trurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66aff69a2b7a173f02e50946918441fe9f37146b880319bef235e1fe41e1a8c3"
    sha256 cellar: :any,                 arm64_monterey: "85053c1512b84feaab1c8a1356d7a0b5ca4c5250884131b99bb325a7791127ea"
    sha256 cellar: :any,                 arm64_big_sur:  "50af1bb799bf25da845e027c74fbbad1695f3de672099da512418b34e09b01d7"
    sha256 cellar: :any_skip_relocation, ventura:        "13639d4eb0c341705953748ac7ba01771a3a52144d129ed80dcce2e23f8181a9"
    sha256 cellar: :any,                 monterey:       "bd5399456f622cc57ce403dcd08fa946e84ebe952b333bc9099aef1fca97a0a4"
    sha256 cellar: :any,                 big_sur:        "f64d616f19edc5e7252cdf68c3ad2f77b595db289d04a11c7e09306674000f5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa32008f4c49b68d44d165a9d6e2a52229db9a0ea58ff867f4e2addbe81d1ff4"
  end

  uses_from_macos "curl", since: :ventura # uses CURLUE_NO_ZONEID, available since curl 7.81.0

  # Makefile: fix build with GNU Make 3.x
  # Remove on next release.
  patch do
    url "https://github.com/curl/trurl/commit/017f91cd4e89a6df4fca32602680e785149ad9c2.patch?full_index=1"
    sha256 "0fabbb8f377b4a7a7535fac1dad8a7ffb1b86ddfdf716a72f5dd636afb2fdb98"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_equal "https 443 /hello.html",
      shell_output("#{bin}/trurl https://example.com/hello.html --get '{scheme} {port} {path}'").chomp
  end
end
