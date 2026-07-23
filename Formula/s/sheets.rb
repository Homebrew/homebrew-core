class Sheets < Formula
  desc "Terminal based spreadsheet tool"
  homepage "https://github.com/maaslalani/sheets"
  url "https://github.com/maaslalani/sheets/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "d65b37c4d40c0a531a87a81848350528387e1247b24d2aa3a04dd5a41338c9fa"
  license "MIT"
  head "https://github.com/maaslalani/sheets.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15ae8d60a16d08c389fa2c33698848b1f17d865c1627be3a6a254ca71dfa3e33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15ae8d60a16d08c389fa2c33698848b1f17d865c1627be3a6a254ca71dfa3e33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15ae8d60a16d08c389fa2c33698848b1f17d865c1627be3a6a254ca71dfa3e33"
    sha256 cellar: :any_skip_relocation, sonoma:        "59d347c63ceb2a43890ca4862b476bbec5e19512c8eff2146f16addee79631d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27b105d00a0fc10b20c8a57e4fd27d1b96face42d7e25c1168f26796677ebd26"
    sha256 cellar: :any,                 x86_64_linux:  "c49e18d4858247288bedc2da9e2d283e677f7579022f48f2bf1c93f97903ffd2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"test.csv").write <<~CSV
      Name,Age,City
      Alice,30,NYC
      Bob,25,LA
    CSV

    assert_equal "30", shell_output("#{bin}/sheets #{testpath}/test.csv B2").strip
    assert_equal "Alice\nBob", shell_output("#{bin}/sheets #{testpath}/test.csv A2:A3").strip
  end
end
