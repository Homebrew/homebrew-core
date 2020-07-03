class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v5.0.0.tar.gz"
  sha256 "fc3ae25c550b66270457c11778bddcbb3b664638f5181f388262bf40e8811124"

  bottle do
    cellar :any_skip_relocation
    sha256 "427143c2fc6d3f12608590a1a6eb3c7fcf4b0a4e2f8b7e7a596685297e6b42c6" => :catalina
    sha256 "10706af6c3d2220045fe5ab4c4977fe1a5ad08a5d52601ca0dc2477d95bfba1f" => :mojave
    sha256 "0deafb0c9c7fca254e521cc9cad7fe1fd36ee138878680059d0503a6d2c1326b" => :high_sierra
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

    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
