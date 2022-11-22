class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v1.29.2.tar.gz"
  sha256 "0b2ff1e468d20388c382341068eea25e3e45e628220c277391aee1e21c0223a1"
  license "MIT"
  version_scheme 1
  head "https://github.com/thoughtworks/talisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "541f72685a8df25e8031c9951276ba1d2323a14bbba5d60880d6360923535671"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c56fdba2400f8e5d3df8d6b8f9f0de0d6fdb61e894aad3f863389cbc0178da6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b80a7c66a263f9438112208a1ff916b97eecf6b7d6966f0f06207442bcc0efa"
    sha256 cellar: :any_skip_relocation, monterey:       "7fc681fea70b4a30a981e30bb2e76739d7208393b02dae3da4d80a36077f1787"
    sha256 cellar: :any_skip_relocation, big_sur:        "1592c9a28aaaa22c87be1c0479fe38984e3da2831366df1d63d2527060ef1a2d"
    sha256 cellar: :any_skip_relocation, catalina:       "dce433e3b1c99a38c8184e6bb89c1fae0dba95066a05c2682b171ea3ca87e250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64cef22e18d76c2db97e6b2f733efcf5762eb4d00bed605f4816bb6a28a6da07"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
