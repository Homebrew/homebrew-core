class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.32.0.tar.gz"
  sha256 "e81cfc94bc15faeb1cacaddcea20e6f8220e6d288b84dfdf221c17d4868de2c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e70333a91c3ff6593f781c856aaafa9afa58871764b812926cc6096e89e697c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df70d3600ba9c4472b5ee4a576fa7799377b096e017cf69c78002d0e93c327d7"
    sha256 cellar: :any_skip_relocation, monterey:       "1c62caeb6aabbd116a378f255e314877abf1f25e942448409b136bc15b2b9214"
    sha256 cellar: :any_skip_relocation, big_sur:        "37cab6ebe1c45369a4fa1c7f1e6b7adc411699ba0102c63988582d800ecaa9d9"
    sha256 cellar: :any_skip_relocation, catalina:       "4be25f9cd3b414d245daa154f707215663862d97595e483c3598f0ef14d07b2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b36e8eeccc5ad51960245a2341e67d6d4dfaf231d0335416b885d87c92a4f016"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
