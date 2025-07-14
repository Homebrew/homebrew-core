class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "eb9dbc135a28b53a3eb359a4170416128a2424c47c80ba823415989350c7021e"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "008ac24d0675df1e098d15ac9dba4a887d372b4c52ed0151e822dacb1f973127"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f915e8ac7692c8c2003268d43586b1a35f0c0fc7f729de9eaf876a8e079e85e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a28f8c5dddb8ed844bfd638597eabcd471ab6ec242cd730179eb3d7863ac25d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "aedec6bc7312b5e23860eb098d01f85f85c1ccd4971b904079949bb9fd9dff34"
    sha256 cellar: :any_skip_relocation, ventura:       "5a21ca034f7d058a53e74002253a561b613bdfa54fb5958b6b076bfa6d6427a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10ee90e9f5efc0337e8bb8ae2da70e522bd685742de202e9e551958c68901df2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca3c845fbefa047626ba99de4aadd16cac6f5f3c31ec4c5dbea418d09d3dd764"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin/"usage --version").chomp
    assert_equal "--foo", shell_output(bin/"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
