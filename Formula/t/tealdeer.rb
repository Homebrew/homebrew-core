class Tealdeer < Formula
  desc "Very fast implementation of tldr in Rust"
  homepage "https://github.com/dbrgn/tealdeer"
  url "https://github.com/dbrgn/tealdeer/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "940fe96a44571f395ac8349e5cba7ddb9231ce526bee07a9eb68f02c32f7da7b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dbrgn/tealdeer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf60e967be7a644346440663e0b9eb534868c91c54e75438cd372de8f2a6eaa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c304880e3b6f5bfc8dbdc8dc554d7fe7e1b0ff3622ef21d43edc878f7bb3d275"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1eed75f00e0f33155fb5ef289cd00e098ce51c49b328afd3e6463cd76ec8220c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4590f9b5420367d9d4af16e6ce8fde5eb0b6fa94d7a838ca7f3765b44f05634b"
    sha256 cellar: :any_skip_relocation, ventura:       "25fdfaa03e8701027863838377388100e7c392d562dde7ed66d9eaab60c08d7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5d0c302d4a8bcf82559c0ce7be9a36dd483ef4b3bcb69287db8350ca4ef5ce1"
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
