class Wego < Formula
  desc "Weather app for the terminal"
  homepage "https://github.com/schachmat/wego"
  url "https://github.com/schachmat/wego/archive/2.1.tar.gz"
  sha256 "cebfa622789aa8e7045657d81754cb502ba189f4b4bebd1a95192528e06969a6"
  license "ISC"
  head "https://github.com/schachmat/wego.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "263a710351268d557df2dba814bdfeee839259822a3c39585b228a6e0cfc38dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e7809fee9e62e0aeeb501a13e3ee9a760e646d3df267d86c78875285f92ec0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48bddc880f5aefc99f67e4ec492e2bc95b35d5337864eb44eea34ef79ad7f55c"
    sha256 cellar: :any_skip_relocation, ventura:        "b0d83c843b79f8cd45888695db3aeca749bc3fc6fa74ee54ae5472c608ba6bd6"
    sha256 cellar: :any_skip_relocation, monterey:       "28aa7cd9c990adca931cc0ae80c226eea67b448f7c4732cdcfb1850a4b0d906a"
    sha256 cellar: :any_skip_relocation, big_sur:        "68076fd25f18feff40f249330b10ab5e26730296f1a5934581abf049e287aa42"
    sha256 cellar: :any_skip_relocation, catalina:       "18352908f8e018f7a6031aeb0f816d11410c04a250031812a0aa69fab0f2c3f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee3da37c7f2b5a15c5c6da56eec204c7d32356c50553969052dab69a8b1caead"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["WEGORC"] = testpath/".wegorc"
    assert_match(/No .*API key specified./, shell_output("#{bin}/wego 2>&1", 1))
  end
end
