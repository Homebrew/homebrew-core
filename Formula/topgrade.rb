class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v6.2.2.tar.gz"
  sha256 "385cd9334865051b5d6a5ba170b96e78e2913d6530ddcfcdf72590c382e3f065"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "96c03f055eadaa103d9ade521fef1454e53e163c9f1f5863bd6c61dabd5c9692" => :big_sur
    sha256 "bb4af38c15c172e9c8b5e14512720443150a32658003f6d7c958ade24e04b2ce" => :arm64_big_sur
    sha256 "651c6abd2a73edd00976537eabedfbc9f5140e1e1d11aed06848b0be64327fc4" => :catalina
    sha256 "151eb4b9654ac1524ba999d95527cae981d1337ad3959a4ee3f04bd498902779" => :mojave
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
