class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v5.3.0.tar.gz"
  sha256 "4218396301113a31d457cd06188dbc5926caa8cfc5cdb12b728c82102f242525"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ad9f6d28a77af2e004a2bd811b036d488e79351d6c24d823d2b40791538c852" => :catalina
    sha256 "5c83b9683d719042cb2be454365d195fe5e9225c3cc726bdf0f69c3f32d24bf2" => :mojave
    sha256 "a37f75d0c839a9628c299c2938420b2d58725477e91275a36772fd18e1faea04" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on :xcode => :build if MacOS::CLT.version >= "11.4" # libxml2 module bug

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
