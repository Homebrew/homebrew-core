class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v4.9.0.tar.gz"
  sha256 "0466843e340e7614c1824ad97beab504dfab0d4392620cf269a7c13c3c4351be"

  bottle do
    cellar :any_skip_relocation
    sha256 "a26ce1e183aab8c7a1d2c4e18810827d5ab3732bca7eed138e998685b291ed23" => :catalina
    sha256 "4cfea55e6d84600d1dad5612ab85a6325c01dce534e6446169e6bab56d4e25ca" => :mojave
    sha256 "ff0ca11f4059575d2ae762b324321190fdb5ca15446678b13dd9ee52f655ff52" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on :xcode => :build if MacOS::CLT.version >= "11.4" # libxml2 module bug

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
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

    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
