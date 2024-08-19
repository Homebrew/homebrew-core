class Swiftplantuml < Formula
  desc "Generate UML class diagrams from Swift sources"
  homepage "https://github.com/MarcoEidinger/SwiftPlantUML"
  url "https://github.com/MarcoEidinger/SwiftPlantUML/archive/refs/tags/0.8.1.tar.gz"
  sha256 "1529dafcfd3e7c20902bee53100a0acee55a80e373d52a208829649dc961e2b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "494bb09eb5cc7d9dabcfdac317baf2b5939edcbbba51bcde099bea9d1068cb58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bdc52a8007de3f0043a220e2a26ace19bdfd906d52b5157a49a1b148466cfc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5e3a4d3fe71467bd150d18789322c7cc0a842d54077c6932b173ebee3ab7fd1"
    sha256 cellar: :any_skip_relocation, sonoma:         "cfda85ba53b6afe004e3868e38c8f22c52b397ac215bf05e29d2c68fa45f0960"
    sha256 cellar: :any_skip_relocation, ventura:        "811c2c81ab2d87633a8be92d5553df6aaf36ea6e573759a736a0f2561355c77f"
    sha256 cellar: :any_skip_relocation, monterey:       "d479af32707f10b82e2de01e879e95f6fcfbd4ace0d37c5900823f7873ccdae1"
  end

  depends_on xcode: ["12.2", :build]
  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"swiftplantuml", "--help"
  end
end
