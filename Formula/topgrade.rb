class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v6.5.1.tar.gz"
  sha256 "3090c46a98a29410d6889dfabb893e388e9c73d429571b99271d653150a41627"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f03ddf46fc91148504c54456c07ddd4dc3fe05900a46dc4a8809150236594375"
    sha256 cellar: :any_skip_relocation, big_sur:       "3c3f1359f250d71ea4a54a279ad303170a27bba32f6a07b27f9833ecdb3ef82f"
    sha256 cellar: :any_skip_relocation, catalina:      "5eee5154ca65852111e6bd23c63579e642214fc8ab1ad826abe65bd42e11746d"
    sha256 cellar: :any_skip_relocation, mojave:        "54a40ba739ae9b28e37b3303c7b7e4a8ff1e8a7d5bde8f7b8d2a9e011ebfb28b"
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
