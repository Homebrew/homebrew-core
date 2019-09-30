class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v3.0.2.tar.gz"
  sha256 "f0b6e3f4cff2040f62ffba6dfadaf4f62a652d018967c7184a8abaa9004121f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "633733601bf0d74903248ef332e4518e953f07a4cc0c5af7f66c77d94d429e18" => :catalina
    sha256 "5fcf11837e9258c5c6ba2f3c5c7e33f9327fde4e08a72dbd0b67d336e3575885" => :mojave
    sha256 "5e57ae993fe274869820084dd971cfe90b20a0a1611f81761328e81094e61e71" => :high_sierra
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
