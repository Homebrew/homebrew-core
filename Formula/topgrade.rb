class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v3.5.0.tar.gz"
  sha256 "2a3d7518eef34faa9c447e71a11b70442db94383d83a8944effa0795b1ec3e8e"

  bottle do
    cellar :any_skip_relocation
    sha256 "6bd7fa1fc8760f53a10424a44971fe20e9f30b24d708b8ff4b472cec7e873975" => :catalina
    sha256 "e0ac6383b65b4613ab9310a7d43c503d5144a804ab3b53018bb249713de6aeeb" => :mojave
    sha256 "35101c9a7156057916cabccf5cf5bbb07acb227976cfd4ae88d957ec2ebc1811" => :high_sierra
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
