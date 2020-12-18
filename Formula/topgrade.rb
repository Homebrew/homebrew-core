class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v6.1.0.tar.gz"
  sha256 "afbc8fd7c3a4a08a0260fb8bf49f68a6dda4169deb57da3c17ad7e055ca44800"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "de8842a4d6f1a9e4670a62119cce25783297a22a72da6b5950784ad89ba099d3" => :big_sur
    sha256 "3920c699915b4c7125057e2a63bbfc270fd2239bd55a197d82e31a90d4567351" => :catalina
    sha256 "f8b10e6842eb884b8f2b8eb3ee37a647479b79d4d1dbc6446f34f5836c99a988" => :mojave
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
