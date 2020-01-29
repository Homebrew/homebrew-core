class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v3.8.1.tar.gz"
  sha256 "df2f26ceb530f9805375947b26008704539c3eff526e2a5cc12d525c5fd2770b"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a9fee6cdf406529dae5ec2de082a262875886651cf283401d21016f7036f6ce" => :catalina
    sha256 "9e7b688efa36171e0e47e2756fd409ff8e5ccbfd147197b1813021494b5b4e18" => :mojave
    sha256 "cf7c9efdfa5ac6ecbf34501788dfe55a861a38405a034a1dcfd89ae57188ba99" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    # Configuraton path details: https://github.com/r-darwish/topgrade/blob/master/README.md#configuration-path
    # Sample config file: https://github.com/r-darwish/topgrade/blob/master/config.example.toml
    (testpath/"Library/Preferences/topgrade.toml").write <<~EOS
      # Additional git repositories to pull
      #git_repos = [
      #    "~/src/*/",
      #    "~/.config/something"
      #]
    EOS

    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
