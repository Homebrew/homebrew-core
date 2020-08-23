class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v5.6.0.tar.gz"
  sha256 "8cf21d579ecd7be290f307b8dd4a72b7bcff6b24463b1663c6ee754f0f17d6a0"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "97e65246935be9ae6868ead6e0a61ccee5fc13b10869433c3a242563664771ce" => :catalina
    sha256 "8703e3da5642158847e4e6b058e1d9c8fdba03cb2a3507b24d30e9f903f21558" => :mojave
    sha256 "4a7779f8d1cd9a1fb7eeadc210ac726c2df724bc5f8be78cbf317e8fe95b6cb9" => :high_sierra
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
