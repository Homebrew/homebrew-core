class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v6.2.3.tar.gz"
  sha256 "bc1c385be2003462af1bc21fd0556bff88498bb510d80c419ead7adffb4239d2"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "32c581b7cf70b69b11f3612c7a0fe5f18244ba7b07c8029e2c84f209a3028a1c" => :big_sur
    sha256 "5fb852456ab2be99cf69d53973ead4eb3d981c4c467bcef81ef638a03bdedc25" => :arm64_big_sur
    sha256 "bae219e1b7bc6a2b1c71d3a083a080f43e65e052c1c66d58df880e62d1d9749c" => :catalina
    sha256 "fa19ea1c24e448a1599fca74af25998c966739adb0d0ca52e58aa5017354a284" => :mojave
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
