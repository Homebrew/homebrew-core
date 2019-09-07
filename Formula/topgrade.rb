class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v3.0.0.tar.gz"
  sha256 "3000febe4f52091db3a057188c805a3f03d25a2ab8babfa8a2af93d94c1afed4"

  bottle do
    cellar :any_skip_relocation
    sha256 "065e33f3281ab962f2d302cc378a31ba5fd8b1220f5f75e2e68b33f3501e961e" => :mojave
    sha256 "1a89fce00330f284d9e530179b49e43a8f5a6c92699d6380866b2d76caab0d9a" => :high_sierra
    sha256 "7b12a483671cd4f3f9ca7646b531df055fff7df7c6369143c8b175f77379d44c" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
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
