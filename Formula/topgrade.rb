class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v3.2.0.tar.gz"
  sha256 "2e336f3ce56297a2eb7c225bc905a3b1e275d64c7db72e68d80834978a304ebd"

  bottle do
    cellar :any_skip_relocation
    sha256 "4770ea558f7b52fd340366b49cc12e6219a556dd41db7345adca042905dfa1ec" => :catalina
    sha256 "328779d4d57b39029523affbe5b1178e58b5df7d1d80f6af504867766f946793" => :mojave
    sha256 "6bb1a3cfe11c053c1958a744d18d00ded45747f09ffd2aef7ead683a34604324" => :high_sierra
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
