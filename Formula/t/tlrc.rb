class Tlrc < Formula
  desc "Official tldr client written in Rust"
  homepage "https://tldr.sh/tlrc/"
  url "https://github.com/tldr-pages/tlrc/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "8d40c00189fd4a0e359612507e1b8fccc38e82594243bbccdb294e1281c6387f"
  license "MIT"
  head "https://github.com/tldr-pages/tlrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fccfb807af99f23e4ef44de7f91bc660ee0e7b2ba21a9feba11305c5f1971ad7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9953ea898f658be850c4b10bedf00342f23d31e0925f84347402107165558260"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3255ad2f53cc0f90b11ea19d9296d0e001ac6f4f6d3f6a9b1f8e6de40977b90"
    sha256 cellar: :any_skip_relocation, sonoma:        "23ec564226684e20c088034319485a8c17872da8d5f2bae7fa7a9c6b528b2f80"
    sha256 cellar: :any_skip_relocation, ventura:       "1c43af1c49a9b3be850d75f8698ffa54e0f9b71be0d08e90ad66d881f3b39aa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dd7f86a867bc19d3f1234b013a2b96b26d3c422872933cb94077e936e5cafc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feff4684f0afcd04cde1fabab3cbd25c56df45d109e45e448782da4e15c67d55"
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
