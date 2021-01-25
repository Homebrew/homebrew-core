class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v6.3.1.tar.gz"
  sha256 "4527a6e0763e8a9f30bddb83c2ad696a5e13c8c5510e2696c54243c83bbc3f15"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ba3769b11ec41cd6f0b2cc9e62c280d62a64b2d05ef1897ad1cde756eacfad7" => :big_sur
    sha256 "e5c10e18a23f59481c9cadcb9821fc7794aed86335e9ab639b5ad2aae83d130e" => :arm64_big_sur
    sha256 "ad6b11caa9b33bffa41af8c9b96779f1d70657068a52ba1fa290be6671bd24d1" => :catalina
    sha256 "fba4f48248368c1de106a2d0f21ee80a9dffc6e51d2c7dec6237e24fe6f8356e" => :mojave
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

    output = shell_output("#{bin}/topgrade -n --only brew_formula")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
