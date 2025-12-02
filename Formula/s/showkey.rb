class Showkey < Formula
  desc "Simple keystroke visualizer"
  homepage "http://www.catb.org/~esr/showkey/"
  url "http://www.catb.org/~esr/showkey/showkey-1.9.tar.gz"
  sha256 "7230aed91f9a510ae5d234a32ba88402eb6c39431ad8175e78035f9d9b6a8f6e"
  license "MIT"
  head "https://gitlab.com/esr/showkey.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1c630fa31441f7dd28d2031d45523f39ea47e8fa55c8c9f8b2b35966690b7955"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b6d6a1358818a0884df47d8720be947074ba1e261f22856c546161ed620dafbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40f2d4aa914a8823995425bbae6f33e4e8a8a3c2c0bc406e7bf4e0299b52cbca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff8fa9772d85597f5c8caaf9642f3ad0e8f622de71080cb6a29089bb47445b66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a86590d6ec04487c561c424ea8d870dbda92fc2981ea31627a79193abf76f097"
    sha256 cellar: :any_skip_relocation, sonoma:         "4af765defe4fb3b6c3dd2a5ef15d3f1a4d5b3521ccd5dbaa35fd0b04e29a7e55"
    sha256 cellar: :any_skip_relocation, ventura:        "5e49308c5c35d9d773e7a523faec8d355f05f313f0df6daed0175166dca58d3c"
    sha256 cellar: :any_skip_relocation, monterey:       "1347c7b79e61d9b55735600a10f9bed5ea95a258723c11859f5125fe0ed41dd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "05a4d7762f25e11ac1138e807470b910b4c7b370c7cb965f207f8f3ace251189"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7921d9e1728c1576d6659fb218eabc169ae70c9fbe9396609b6e862145b0ad47"
  end

  depends_on "xmlto" => :build

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make", "showkey", "showkey.1"
    bin.install "showkey"
    man1.install "showkey.1"
  end

  test do
    require "expect"

    args = if OS.linux?
      ["script", "-q", "/dev/null", "-c", bin/"showkey"]
    else
      ["script", "-q", "/dev/null", bin/"showkey"]
    end

    output = Utils.safe_popen_write(*args) do |pipe|
      pipe.expect(/interrupt .*? or quit .*? character\.\r?\n$/)
      pipe.write "Hello Homebrew!"
      sleep 1
      pipe.write "\cC\cD"
    end

    assert_match "Hello<SP>Homebrew!\r\nBye...\r\n", output
  end
end
