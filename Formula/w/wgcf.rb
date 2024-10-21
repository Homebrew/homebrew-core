class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/refs/tags/v2.2.23.tar.gz"
  sha256 "01851eee54954174bc7a0b6528252f5aee0d7996d48094f266011db3f20b1554"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8e9b7e693a160e476f66d0d5bdc0fddfba9049607728223e984340beb9e5a2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8e9b7e693a160e476f66d0d5bdc0fddfba9049607728223e984340beb9e5a2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8e9b7e693a160e476f66d0d5bdc0fddfba9049607728223e984340beb9e5a2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "813d70622f506d798ac18a01365536b327fab2d18300e8919bc52b1b3a7f6b87"
    sha256 cellar: :any_skip_relocation, ventura:       "813d70622f506d798ac18a01365536b327fab2d18300e8919bc52b1b3a7f6b87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dccfe23fc6f423ca731b56924a44f138907a0a35382b1592a22e3a0406f9bf2a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"wgcf", "completion")
  end

  test do
    system bin/"wgcf", "trace"
  end
end
