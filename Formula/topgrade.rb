class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v3.0.0.tar.gz"
  sha256 "3000febe4f52091db3a057188c805a3f03d25a2ab8babfa8a2af93d94c1afed4"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e45a3aa49b51fbb1694145160d7aedb0b49ce7957f48f8cbe1a1627d7edec29" => :mojave
    sha256 "04be82c6eb8b4c84f89370ec7193f1f5487e552ea381e06cac7c8833ba76651e" => :high_sierra
    sha256 "57f43dc7121add84793424024cda9382218b7e65c7cebef4f08a9766f487f68a" => :sierra
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
