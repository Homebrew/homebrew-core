class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v3.8.0.tar.gz"
  sha256 "0a9bfcc8a2ea87d6549de159de57f08eba95c81456c02631cd87b6e63febdc0e"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a7b2ae994621388678dd1a990f2bf2838e14176a9063518742afc202a8f178c" => :catalina
    sha256 "c879061ae0b8079f72fd3cda99183fb8116912a3d141b246979248393b778073" => :mojave
    sha256 "8208b232fd3ab8967b83f73fb25b70993a21dc962011b06ac484ca9decc2da3b" => :high_sierra
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
