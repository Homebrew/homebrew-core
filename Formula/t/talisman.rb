class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "916d4a990f9ca5844a36ac8e090797cd26c8c1c8eddf5a7aa659e2538a865151"
  license "MIT"
  version_scheme 1
  head "https://github.com/thoughtworks/talisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "589190a842deb2f63ad319a47cf50a4eafeadc4117aaf9bdd6b965a2f072dd9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7789c90531ec94bdee710f9d6c83b4e86cb28d2a735b32971af98fc4576bb3a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50c984d272b1407a5fc1c84ca1088ef6630d4734f98a4b29bb268fcfd74ba168"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecef5b4b9328debcf9969851dfd49153978c19f557b04841fa625a16f114066b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ae3401955d30f2728ece81141c9a872b101a2c5b6f7d6a20f77d9f31cef93dd"
    sha256 cellar: :any_skip_relocation, ventura:        "49cfbc05da75a73120b30b1aa929c52ade7664bd2d47e89a5eb9343f31500979"
    sha256 cellar: :any_skip_relocation, monterey:       "666e050a5fa529a2ac8aa2050ca6565d3ef42810a3c61135a47fb83b1b8bb3e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ac7d4baffe8894e5b8b528f291e3ac366f4258063238d29d1d6bd38fede9941"
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
