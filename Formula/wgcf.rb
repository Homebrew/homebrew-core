class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.17.tar.gz"
  sha256 "04320b13b766bf8a89af55441c119c78814aadd7170592aaa724ca9c59b2a1a8"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bcb5fed9aaee000c14d431083b677cf826a088bff0725d386d71b4fe3beba92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bcb5fed9aaee000c14d431083b677cf826a088bff0725d386d71b4fe3beba92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bcb5fed9aaee000c14d431083b677cf826a088bff0725d386d71b4fe3beba92"
    sha256 cellar: :any_skip_relocation, ventura:        "550146c79ff31e6d6a77388b1300892ca85ed0e98c029e880906f81305411d99"
    sha256 cellar: :any_skip_relocation, monterey:       "550146c79ff31e6d6a77388b1300892ca85ed0e98c029e880906f81305411d99"
    sha256 cellar: :any_skip_relocation, big_sur:        "550146c79ff31e6d6a77388b1300892ca85ed0e98c029e880906f81305411d99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47359f427ff529fb4df0d66a6c015fb6b88edc465607c2f14cf3b6d6261259ee"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"wgcf", "completion")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
