class Showkey < Formula
  desc "Simple keystroke visualizer"
  homepage "http://www.catb.org/~esr/showkey/"
  url "http://www.catb.org/~esr/showkey/showkey-1.8.tar.gz"
  sha256 "31b6b064976a34d7d8e7a254db0397ba2dc50f1bb6e283038b17c48a358d50d3"
  license "MIT"
  head "https://gitlab.com/esr/showkey.git"

  livecheck do
    url :homepage
    regex(/showkey[._-]v?(\d+(?:\.\d+)+)/i)
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

    output = Utils.safe_popen_write("script", "-q", "/dev/null", bin/"showkey") do |pipe|
      pipe.expect /interrupt .*? or quit .*? character\.\r?\n$/
      pipe.write "Hello Homebrew!"
      sleep 1
      pipe.write "\cC\cD"
    end
    assert_match /^Hello<SP>Homebrew!<CTL-D=EOT>/, output
  end
end
