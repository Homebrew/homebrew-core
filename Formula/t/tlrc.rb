class Tlrc < Formula
  desc "Official tldr client written in Rust"
  homepage "https://github.com/tldr-pages/tlrc"
  url "https://github.com/tldr-pages/tlrc/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "5a103e9d77e5a5d02b4e7ef98a3ab8e5fb1e4a9a861ea0cd19ab3002daf89fed"
  license "MIT"
  head "https://github.com/tldr-pages/tlrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c5c04dd949a1852ac74d47806edbf9d66a934bec8a25e2a7ef14c5cb561b74d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97c5f4c368464e2a079eb997db14556449c08f6dfb89858b6632bf788656c2b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39e600c9bb0e372fb96fa13ad6d21b19a50e5a12b2f71a57ab75420dfa67b32f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4cab0cdcad86b09de10562690684780df7ab386b8d6123ed5e6e62e1d44996d"
    sha256 cellar: :any_skip_relocation, sonoma:         "9624494a35da5d9c819e8bc326df3c443b5764f9715a44ce65ff0f3ed87ba40d"
    sha256 cellar: :any_skip_relocation, ventura:        "5703ac062d93becf3a675c73e580e40833352824b72af8eba542ab26840fc1b1"
    sha256 cellar: :any_skip_relocation, monterey:       "43352a252db7eb809704ec9a6b5d51efaa3de8c9c45792106b321121eb5858ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f434a74662a50b963fe7e58804f2d88aad7f637e041a95cd6e1001f4321c399b"
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
