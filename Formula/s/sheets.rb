class Sheets < Formula
  desc "Terminal based spreadsheet tool"
  homepage "https://github.com/maaslalani/sheets"
  url "https://github.com/maaslalani/sheets/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "d65b37c4d40c0a531a87a81848350528387e1247b24d2aa3a04dd5a41338c9fa"
  license "MIT"
  head "https://github.com/maaslalani/sheets.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "84c9a3b675e7941fd2ee3647abc7e3e7fd862341b4a143996a89a470587d7e26"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "84c9a3b675e7941fd2ee3647abc7e3e7fd862341b4a143996a89a470587d7e26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "84c9a3b675e7941fd2ee3647abc7e3e7fd862341b4a143996a89a470587d7e26"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dfa442e0355f7672dcca1603d2f08b8b0e599140ba2cb0bd674a4de28a6560d6"
    sha256 cellar: :any,                 x86_64_linux:      "ba9793cc9d23ae120525a3d42360b99fa24641cfe9889c0c0bf7d224654d9bdd"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
