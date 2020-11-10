class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v5.9.1.tar.gz"
  sha256 "fea2053a667546fe4f6fa722e3cac2f229c6abdae78f220a4dda25398ba2494d"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b5448893b58f284ca35f156ca9f4dbb743de2d65e9acf48c3357bbfffa200df" => :catalina
    sha256 "49c432a7bad1d0ff9b45966afe5cb55152a7b62d72793c5ba855eae59161bb71" => :mojave
    sha256 "d8770839d13ab4df43886f044d8a3eb68dd71f0c0a52715c780dc16b01be70a9" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on xcode: :build if MacOS::CLT.version >= "11.4" # libxml2 module bug

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Configuraton path details: https://github.com/r-darwish/topgrade/blob/HEAD/README.md#configuration-path
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
