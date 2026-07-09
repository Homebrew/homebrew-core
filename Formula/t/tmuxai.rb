class Tmuxai < Formula
  desc "AI-powered, non-intrusive terminal assistant"
  homepage "https://tmuxai.dev/"
  url "https://github.com/alvinunreal/tmuxai/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "0ccb8881c5af169eaf2c9d171791742e8580311e12582adfb73988ea9fd2ee28"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba6970fe914485b01129d6616002006e283a8ea11c83d075d571935b72c334aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba6970fe914485b01129d6616002006e283a8ea11c83d075d571935b72c334aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba6970fe914485b01129d6616002006e283a8ea11c83d075d571935b72c334aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffaa2841e0ac7d4de8494659505e0ce7af9ab6635f0b1b29e1af9b3d075b970e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc887ae39907b63ad85b1074631cc6e0c4de75f18e42190ffae15dd201d0a6aa"
    sha256 cellar: :any,                 x86_64_linux:  "c192c379b3328c7e59b94cc9926490e9f2963ce705870bca55694c4ee914b65a"
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
