class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v6.3.1.tar.gz"
  sha256 "4527a6e0763e8a9f30bddb83c2ad696a5e13c8c5510e2696c54243c83bbc3f15"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "5df2f1c455ccda9cb160c18a20373b789cdf08e19ef30994d922845bf3129383" => :big_sur
    sha256 "62eaf462419b3a2a07c0bbc1f8558190610fb88361da8c0dea5ef8e0db26bcf9" => :arm64_big_sur
    sha256 "5c7ad615503f15b486bc68fb23a96006978ccfc3a16d22e494d0c806ade4b8df" => :catalina
    sha256 "52efc526568273d61121def370127b4c8e9d020065bc7054a6f48cfca1f4a733" => :mojave
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
