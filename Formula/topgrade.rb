class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v10.2.1.tar.gz"
  sha256 "0e98f5c61914e88fa2437c539899c4f98ca70d9dc91492e35afba1cc8eb2092f"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be61a6d5a52d399009141e985c3ae1377432cdd258a1c850c0a9f2a40eda45a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21218b52c1469516333ed88468235b69054ca67d2033d61a60ae4e00c06845c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cf03f1d04eee0b769ac32372f20512a7b91d2da5d4910d5cd7e2330d9c98691"
    sha256 cellar: :any_skip_relocation, ventura:        "134ee6b94adea333b8f0aa69cb51aad59d4c36f07604f27d3008b50320bea1ab"
    sha256 cellar: :any_skip_relocation, monterey:       "89c839ab77dd40616c5a44f56098e0ea58b39a0a6e4810385e0b64bd7b829716"
    sha256 cellar: :any_skip_relocation, big_sur:        "104eb42179e3c68506c02713b3f42e1039400e385bfa3834e5b7fd9d3ed4510e"
    sha256 cellar: :any_skip_relocation, catalina:       "7ddf8f8ae35900be2b6a52bf571e88b8d18135680ede5ea48133f82ed264c7ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ef93f705ab433972f26b99379faa688d37b2d764b04a5647cfe74c127f7461d"
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
