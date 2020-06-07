class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v4.6.0.tar.gz"
  sha256 "fc1f1efdd1d108cd2c2a39e544c0e11a20cf7460bd8abf22104807b28d33ae11"

  bottle do
    cellar :any_skip_relocation
    sha256 "eccfda22401da7fee64bc93c40fa8f42f0f3b215a10f9ffb30ad56c8a33d611f" => :catalina
    sha256 "80003ae56cae51ed6e79a2546014fff103ce3698b2f7be10eb088a1fa2a50fbd" => :mojave
    sha256 "19c1d15f8263fe51f817fc877df9688b402b28a7c11e41677e9189a6fa7a5c38" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on :xcode => :build if MacOS::CLT.version >= "11.4" # libxml2 module bug

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
