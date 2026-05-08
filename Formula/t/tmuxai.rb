class Tmuxai < Formula
  desc "AI-powered, non-intrusive terminal assistant"
  homepage "https://tmuxai.dev/"
  url "https://github.com/BoringDystopiaDevelopment/tmuxai/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "efbe7df70a07ea0a647ef45ad0ed58a5244f5692188e0f063d0bfc72f88cc801"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48765c1faac79e09c00d6e2b9bd02a1906a94746da0fcb51a15b1ee0492ee759"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48765c1faac79e09c00d6e2b9bd02a1906a94746da0fcb51a15b1ee0492ee759"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48765c1faac79e09c00d6e2b9bd02a1906a94746da0fcb51a15b1ee0492ee759"
    sha256 cellar: :any_skip_relocation, sonoma:        "2719ab2f36f1c446bc982c95911be415e066f58a1e9656ad4d2068bff0e9d588"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8933fa6866f5a51bbcd01a73936f6c9daed8a7cf5c714b3ce0cdee22598dec07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df4df7fd5d37386e9faf5c38d7f0b9dfe890d9607c8826999a8ab40649e38ff8"
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
