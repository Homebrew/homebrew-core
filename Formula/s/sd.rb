class Sd < Formula
  desc "Intuitive find & replace CLI"
  homepage "https://github.com/chmln/sd"
  url "https://github.com/chmln/sd/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "2adc1dec0d2c63cbffa94204b212926f2735a59753494fca72c3cfe4001d472f"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1538e29545abba000fbd4f6f00092a4e5343e280ffaf5a97aa37b316bb4519f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3cf7ab4495f622a4f245bb1c7c30225ef881dc390ee5edc59a1d3c4381cecca1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6bc773a70934364157591cd888e617601a42ed1f615fda8f77364fa45631d08d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "946a44f567e3528d380fbbee742c3abeed9952f53f7de172a846b63d2e21d5b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60f079d38aa238a1e7109c6a0f988fe7033449d20f05db3b87219cbfd945fe58"
    sha256 cellar: :any_skip_relocation, sonoma:         "f83ebe2505106e8c94c4b92d15c0ac3390dc637039043dbafad3e382fa8c61b0"
    sha256 cellar: :any_skip_relocation, ventura:        "0200b81c386198d39ed7b03e85c771e141d9604075d82aa4caed5d5a775486c8"
    sha256 cellar: :any_skip_relocation, monterey:       "a8fee9e7b0202a27d8dcc599ebd391637107134f139dbe88d6b22c880e63d8a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d554d755178dcf4c8c77dc3ce4fe14e3467379df1a45881457124c5a248a9852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c098bdfaff013f7a6b6b96a65b9cfef86926e1cd901b363e1bdb84734ee6e3f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "gen/sd.1"
    bash_completion.install "gen/completions/sd.bash" => "sd"
    fish_completion.install "gen/completions/sd.fish"
    zsh_completion.install "gen/completions/_sd"
  end

  test do
    assert_equal "after", pipe_output("#{bin}/sd before after", "before")
  end
end
