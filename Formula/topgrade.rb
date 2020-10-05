class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v5.8.1.tar.gz"
  sha256 "a3bed226213e9c65e3807f61727c590167028c393ddcea3627cef812258100de"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "724fc82a10baa578ceff0262ba4b6bb2d8782ef5e5d8f8183024af3c4e11506b" => :catalina
    sha256 "79b105490def95e873d678b3d98347df776ca4c700d7f6fcc77d228a76a387cc" => :mojave
    sha256 "6f403ac92f9f5b5b40e3643f239d2143c5aa3daab9c07355efea3579a6fe0c6f" => :high_sierra
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
