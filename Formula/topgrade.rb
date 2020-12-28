class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v6.2.0.tar.gz"
  sha256 "ee23ba04962509ac188ec601dd67c0f8a7eae7d6532155c0eb848756264dbc21"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "03ad4c55d161e794eebc21d4148ebb0c6ae3c6441eff70f1bf736e5dbe287704" => :big_sur
    sha256 "e6bf578a0312967a5cd6947adeac5889aeeec00b224d920213ace6c73a4e5e33" => :arm64_big_sur
    sha256 "18adf109b719ca194203f371b7e26ab69fe5078b65f3643467488c007fc8009a" => :catalina
    sha256 "d43f6d94667974fdb90c5475748e34c9673a3b3dfdbbdca195410b1d1ef07d03" => :mojave
  end

  depends_on "rust" => :build
  depends_on xcode: :build if MacOS::CLT.version >= "11.4" # libxml2 module bug

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Configuration path details: https://github.com/r-darwish/topgrade/blob/HEAD/README.md#configuration-path
    # Sample config file: https://github.com/r-darwish/topgrade/blob/HEAD/config.example.toml
    (testpath/"Library/Preferences/topgrade.toml").write <<~EOS
      # Additional git repositories to pull
      #git_repos = [
      #    "~/src/*/",
      #    "~/.config/something"
      #]
    EOS

    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
