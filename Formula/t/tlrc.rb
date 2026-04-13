class Tlrc < Formula
  desc "Official tldr client written in Rust"
  homepage "https://tldr.sh/tlrc/"
  url "https://github.com/tldr-pages/tlrc/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "be72997481480d66560886d2ff7b1e1d8e086169885d85edee663c9091bd32f3"
  license "MIT"
  head "https://github.com/tldr-pages/tlrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb3541b689da3b76db5bd4682a240c34d25b5d1c183856d0a75ff156a8389e08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d2a1ac7501121a690c323b4d6eab28f33f9943566744adc757b0c7702bf6747"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1283ffdbd2f2c7a6971be0a29bde24aa624a227cb0811c7782713923a6b9c54"
    sha256 cellar: :any_skip_relocation, sonoma:        "c608e7267500f1bdff26a8d5406b1c77523c0e187bae937329f94e01e4e7d041"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98b06542d2f8b3da2b31739f95b2c26caef150b5dd0ef1d138860c723d14accd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "400015d944ed322be4703d6bc7afa9d8c2f46d1fbdd4977751acff79ce633b1f"
  end

  depends_on "rust" => :build

  conflicts_with "tealdeer", because: "both install `tldr` binaries"
  conflicts_with "tldr", because: "both install `tldr` binaries"

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "tldr.1"

    bash_completion.install "completions/tldr.bash" => "tldr"
    zsh_completion.install "completions/_tldr"
    fish_completion.install "completions/tldr.fish"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr brew")
  end
end
