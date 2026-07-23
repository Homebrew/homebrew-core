class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/refs/tags/v2.2.31.tar.gz"
  sha256 "e562efd9496070e0bb22ccc80eff42ba1026a26b10c05fae3866a150aa5200ca"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3ec2dda31c7b14d31f6eb2a1c72fa1475298de9499c517e11b085199a6903a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3ec2dda31c7b14d31f6eb2a1c72fa1475298de9499c517e11b085199a6903a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3ec2dda31c7b14d31f6eb2a1c72fa1475298de9499c517e11b085199a6903a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7aaa094fcf45ccdeeee0ebb450cb8e7e803b746eaa2dad802ad29483991c0382"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db12a185a7f8c924850fcabf1c2a6ca5f02efa763b31e17d04da8b101a1f8901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cb354139e23da0c0d05007da476190cdafa1082e50143028a3bb877c32ccecb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"wgcf", shell_parameter_format: :cobra)
  end

  test do
    system bin/"wgcf", "trace"
  end
end
