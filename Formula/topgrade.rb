class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v11.0.2.tar.gz"
  sha256 "29cd1d870dafbfa46d07c4056ba229a98755660a2e37804f12e1507fdde7d237"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "964752cbd36fdd41a8e8ff7a0133fab9327464ff2a708d3555519156db8493e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3c18350202a4a22fde2514fb1148d33a6654dd0bc156cde95daca1f6219b51a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66b142d3c3722c357c09e715482565a7d5afb6d061fcf26c6486cea7bc05d2a6"
    sha256 cellar: :any_skip_relocation, ventura:        "cef7c8ff85847150e1ca19c01411b690ede315bb125d31f08105d5db0c1caa10"
    sha256 cellar: :any_skip_relocation, monterey:       "b6389cc6b8ff614a5f81338729bb2736ee86f6f7356c56484ad69908e1798d19"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f2b806fc23148935592d8d830ce8ea043d4a51d9f7d36715a0659a8cc7c26ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af426667a3ad33719a60c4ac10fd4757c60ffa17acba7a79cad175350e0756b1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Configuration path details: https://github.com/r-darwish/topgrade/blob/HEAD/README.md#configuration-path
    # Sample config file: https://github.com/r-darwish/topgrade/blob/HEAD/config.example.toml
    (testpath/"Library/Preferences/topgrade.toml").write <<~EOS
      # Additional git repositories to pull
      #git_repos = [
      #    "~/src/*/",
      #    "~/.config/something"
      #]
    EOS

    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew_formula")
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}/bin/)?brew upgrade}o, output
    refute_match(/\sSelf update\s/, output)
  end
end
