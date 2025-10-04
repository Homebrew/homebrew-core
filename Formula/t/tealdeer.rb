class Tealdeer < Formula
  desc "Very fast implementation of tldr in Rust"
  homepage "https://tealdeer-rs.github.io/tealdeer/"
  url "https://github.com/tealdeer-rs/tealdeer/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "b1f1262de60ef3105ff93de71568a68a56ad5874a28f105ab7cb5857d305cdb9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/tealdeer-rs/tealdeer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9ed071cec67ba6f99de640f8752e0974147d86d502fb166ac8fde1a33f8d4ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba274f70026520a3199e64792400c0b92714af8fc2a68a8a513ae811e7bee24f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "691ac8167586b4f0cce7e2d58773141634c4fdbf711a260789a47c38bb5e53b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5f589c151bb427c9798d0302b6b685f2fe91ef03a2e937f4f99452a69e8bd8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c692047199775883070e21df53a7ce1dfec50657f46f4d23596b00de3c10ce8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b5fb8da742b6c1d021f516ef9e1795e9a5c089a68ab978d8fd31c8998a0d19d"
  end

  depends_on "rust" => :build

  conflicts_with "tlrc", because: "both install `tldr` binaries"
  conflicts_with "tldr", because: "both install `tldr` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "completion/bash_tealdeer" => "tldr"
    zsh_completion.install "completion/zsh_tealdeer" => "_tldr"
    fish_completion.install "completion/fish_tealdeer" => "tldr.fish"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr -u && #{bin}/tldr brew")
  end
end
