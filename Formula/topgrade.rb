class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v4.0.1.tar.gz"
  sha256 "d60b28b6c7670453549f6b3b69a43cd8df0074ca988697c4580a2baa0d730c9e"

  bottle do
    cellar :any_skip_relocation
    sha256 "6bf6586bb270bc0768630dc6d2bd2f52de46e95faf188969fd6add66ee9248b9" => :catalina
    sha256 "39c4db4731be9a388432c426ff8d2c89b58715575a446b3baba17b1529864552" => :mojave
    sha256 "3a4553607c507f2ed4973c69cc0d7307c5c5e8de52dbb56fd5476dc072219e8e" => :high_sierra
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
