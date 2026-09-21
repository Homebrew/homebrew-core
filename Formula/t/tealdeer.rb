class Tealdeer < Formula
  desc "Very fast implementation of tldr in Rust"
  homepage "https://tealdeer-rs.github.io/tealdeer/"
  url "https://github.com/tealdeer-rs/tealdeer/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "1387a04ddba714668ff0925377a2de0d0ab14533d44dd0766d673fbbd71e3119"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/tealdeer-rs/tealdeer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bc966189fa9af7f65d8b608535a309a5857e9e766ddf52e2770b2e6fc2a7392e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c3e2109975d3039ec3945ba16dae5267cb0373151d84b6ed88a961a5dccdc08c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9fbf3479e61e34797f4e0efec70f80ed5b24d7efd7da61d99869e704121f6baf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "2c8a304fb5ebdd0981b3835e468015999af4cce43fd0a92549a6bebb1efaee61"
    sha256 cellar: :any_skip_relocation, sonoma:            "59f1baf546aa410a1c2372be9d019a1863400b746aa2a417d5e1eed98cd69507"
    sha256 cellar: :any,                 arm64_linux:       "4a0563dead5e04f640bc5cca2fc48faed46caea0a570dabaf0dfb1f360fa8722"
    sha256 cellar: :any,                 x86_64_linux:      "ad9e54703902ed0445daa4faf1559550f49310c0161e14d483ce0a64dc77f6a9"
  end

  depends_on "rust" => :build

  conflicts_with "tlrc", because: "both install `tldr` binaries"
  conflicts_with "tldr", because: "both install `tldr` binaries"

  # `test do` block downloads the tldr pages cache
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

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
