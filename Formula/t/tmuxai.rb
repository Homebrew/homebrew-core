class Tmuxai < Formula
  desc "AI-powered, non-intrusive terminal assistant"
  homepage "https://tmuxai.dev/"
  url "https://github.com/BoringDystopiaDevelopment/tmuxai/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "3d0a4fe8634831f4c6ede94cabfacca79f49171936469913a527f6c27bed6950"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1f0725f87321034eddbfb9ae4a3d25bdf640b690641b985fef1c97ba3a2c268"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1f0725f87321034eddbfb9ae4a3d25bdf640b690641b985fef1c97ba3a2c268"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1f0725f87321034eddbfb9ae4a3d25bdf640b690641b985fef1c97ba3a2c268"
    sha256 cellar: :any_skip_relocation, sonoma:        "983f393b21594192de4fa414a9695866cd712f8afe032df25e306afad93f4535"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28d556af70a1d4f9ce46eddddd56dd49d6f50824d705982d3a9da8a0f5fb1da2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfde1316ccbfb5a1217ca98355d4d405fea87aa2374bcdf6d54e6285902bcb32"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ldflags = "-s -w -X github.com/alvinunreal/tmuxai/internal.Version=v#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxai -v")

    output = shell_output("#{bin}/tmuxai -f nonexistent 2>&1", 1)
    assert_match "Error reading task file", output
  end
end
