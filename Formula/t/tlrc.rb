class Tlrc < Formula
  desc "Official tldr client written in Rust"
  homepage "https://github.com/tldr-pages/tlrc"
  url "https://github.com/tldr-pages/tlrc/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "d58977a3239538ddaf8b02a54de867a8ac670c2e5770c85f867d54a2c35b016e"
  license "MIT"
  head "https://github.com/tldr-pages/tlrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38212e187ee13fa71c5b632fbf3e28739cea778cf9a2913675be2e4f6413dff0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb9419d545f1c305f9127b09e4dddd9a70b4b82dca9c9d5e4abc9e6825d1f0b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2afb6df9144132962df3b8ffd2db3e156242d9c8b8a17b85e7a39a04565cdbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d8ccb40013ec620c75881838951a7ac69f2103767c83e4ed4bd90e7c692bc7f"
    sha256 cellar: :any_skip_relocation, ventura:        "c58664e48165acace7d4e636a1f925805a9a859b7c15fa83f95a2d47bab28e86"
    sha256 cellar: :any_skip_relocation, monterey:       "55c8a7279a52f1b8978a3c2f381a84d91f3ccb2ddd879e8bfd5cd9774b0d2202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e4487720f752310fd90ff1a1cb6da1ac18b83554fbcb234ab59d934e28123ea"
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
