class Tmuxai < Formula
  desc "AI-powered, non-intrusive terminal assistant"
  homepage "https://tmuxai.dev/"
  url "https://github.com/alvinunreal/tmuxai/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "bf8f27a8527e3de196392ee098029df3cb109d9eec56f4d9d69ff1ff23349416"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5dc7a133131bd0d4d8ce910b93ba143dcefebd68fd48facc08c7078b37c5b7a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dc7a133131bd0d4d8ce910b93ba143dcefebd68fd48facc08c7078b37c5b7a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dc7a133131bd0d4d8ce910b93ba143dcefebd68fd48facc08c7078b37c5b7a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f6032c6d3e357265d83c96bec89d385d565005eabfb421091681deaf709a297"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bba69a198d9f54876f0ae90ee4945955822d90fe117c5c687be08f69cd1a747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cb94895edc37ef1e1d9f1575241ff02445e5de2f1931b74da083a1fc063e80c"
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
