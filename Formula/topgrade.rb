class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v4.0.0.tar.gz"
  sha256 "09162548d6dae1e20722a95ba008be79506faaf25ff9396cb2856eddfc9f75c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb8e62300f5e30207486d03b62ed23de268d0203959f2fd8bf9bd9d7bb1fe446" => :catalina
    sha256 "74c2cb06fd29ea0e72de7ae28df68d56f91112fef487068100c0c07c1b63aeba" => :mojave
    sha256 "6583f2c1758402ac4958c3875d48d5a9c9710fdbd1a50237641731d2592e9053" => :high_sierra
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
