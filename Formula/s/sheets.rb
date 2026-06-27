class Sheets < Formula
  desc "Terminal based spreadsheet tool"
  homepage "https://github.com/maaslalani/sheets"
  url "https://github.com/maaslalani/sheets/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "e33563769858abba1812d6f9e1f427241a9a5c65da3a34a87d8784c8a050e25e"
  license "MIT"
  head "https://github.com/maaslalani/sheets.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb711fb52afd35e5b28695f8600ef9ac1815363a82bbdfb7688bbffe7cd75e82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb711fb52afd35e5b28695f8600ef9ac1815363a82bbdfb7688bbffe7cd75e82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb711fb52afd35e5b28695f8600ef9ac1815363a82bbdfb7688bbffe7cd75e82"
    sha256 cellar: :any_skip_relocation, sonoma:        "24ed5816d010603d66cd4be1b2bf2a565c7f906ed838aef338d153be0d9cc83a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1058fd3f4629b486793774c9b650a459212ac67276e2cb381edc96c3cf702e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6d6801f2dcb174f7c1bd108489ad67ea77599ac47d713b78ef6374179bde86d"
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
