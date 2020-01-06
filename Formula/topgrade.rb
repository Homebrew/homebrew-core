class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v3.7.0.tar.gz"
  sha256 "3aab23ea372cd3dbbb68a45fef2232b39ab668aebda5e19dd0ed47e254913d63"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a255cdd387cebccd4ef5e03e84b68f2b8da26d26d73cb41e7b60fc3cca4e438" => :catalina
    sha256 "60268b66661c3121cc8f5a8d44e710abfacc0887a7a4ff30257315253e688fa1" => :mojave
    sha256 "c6e71a55277f710faa4e595c0207fbde721abc2bce743552db2bab0913b09b40" => :high_sierra
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
