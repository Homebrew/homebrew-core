class TidyHtml5 < Formula
  desc "Granddaddy of HTML tools, with support for modern standards"
  homepage "https://www.html-tidy.org/"
  url "https://github.com/htacg/tidy-html5/archive/5.6.0.tar.gz"
  sha256 "08a63bba3d9e7618d1570b4ecd6a7daa83c8e18a41c82455b6308bc11fe34958"
  license "Zlib"
  head "https://github.com/htacg/tidy-html5.git", branch: "next"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*?[02468](?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3120baf4b5155c0ef5baa272f5a756909cb683c9c9447bdeaf7a07c388376370"
    sha256 cellar: :any, big_sur:       "9c4ed7860ed418e2a018690ee52c83c1a520004bd9d97f7eb6760cf4e82f2af2"
    sha256 cellar: :any, catalina:      "fb2134180fbdb92cc10f3fad33c769073adceb7796e465db7dbc3778f7d3547a"
    sha256 cellar: :any, mojave:        "bd3ca7dc82a913c8576716cbcc957260251132f6dd7b8c526c9ef0c4674faf0f"
    sha256 cellar: :any, high_sierra:   "af9633f1578980fe3d4351c3d71b4b83cc79f814d87310e4b7d05830c53c9621"
    sha256 cellar: :any, sierra:        "6c8f843d25d6964b18d4c2fa15aaf2606b36decbbe65c31b38a7982e499a9d28"
    sha256 cellar: :any, el_capitan:    "48416711a2f1a080e9eae1ecba30773ee48eae98181e25c6ae5ace07cb7ac8ee"
  end

  depends_on "cmake" => :build

  def install
    cd "build/cmake"
    system "cmake", "../..", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    output = pipe_output(bin/"tidy -q", "<!doctype html><title></title>")
    assert_match(/^<!DOCTYPE html>/, output)
    assert_match "HTML Tidy for HTML5", output
  end
end
