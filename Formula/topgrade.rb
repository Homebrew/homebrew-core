class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v8.0.0.tar.gz"
  sha256 "2967bcfb4bc8b45e8aea3cc767af393f2767ad2088471fe1465f0e85a00a02f3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20edf0482b9afe431e70bba0b8156019ccac1e8df8bdf18571a81fc285e329ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd2a43fedf236a997b0a147224005dc8b1d5f450b74d84cde05d6cb1aa8b68e9"
    sha256 cellar: :any_skip_relocation, monterey:       "1a9e164b98e0d8902739322187a8d0576e8bf9ab55062867962a84fba3504777"
    sha256 cellar: :any_skip_relocation, big_sur:        "0df3c739f4330227ad330d94c69f7e6750bb800bd768cbe648cbf4f02b420ecc"
    sha256 cellar: :any_skip_relocation, catalina:       "47d0566f70fc1bdabeeca800c6e3f35782e69d2ae9a7d206948523ed7c8d216c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af862edf8f20068ab2f4e72b3e88efd0dc028cc1bf45b30be2088356c3dfffc2"
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
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}/bin/)?brew upgrade}o, output
    refute_match(/\sSelf update\s/, output)
  end
end
