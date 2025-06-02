class Tealdeer < Formula
  desc "Very fast implementation of tldr in Rust"
  homepage "https://tealdeer-rs.github.io/tealdeer/"
  url "https://github.com/tealdeer-rs/tealdeer/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "d0675b9aa48c00e78abafc318b9bfbcb7ea3cce63e58a42c1f9e2395abcfe0e8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/tealdeer-rs/tealdeer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "762b6cf9ec14e22cdd155410a249c1d1c06132350e3574c9c372a88860249833"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fa102755f201bb1a209fc9006b2106d0a31a09a83648772d78ce30e81060886"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c60761d865a1475a4b04d2881eaec1737c43caaa5498ce0769098071ddc44cd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0af151c2275b86b52ae1c2a38c5705e27524222f7bd23ae79b5092fe348d1100"
    sha256 cellar: :any_skip_relocation, ventura:       "858b2bb36dee9c444b211d2c74cb1b2c85d36362683c568d4e93591095ffaccc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "735bbc2c297439c49cd7331a4729cc93803fc62f20007d6365e73cba2e63e296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0a019576229e3bf8767b4f8fe4aeb32aa7e6f05f5d2ed303be22263e78481fc"
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
