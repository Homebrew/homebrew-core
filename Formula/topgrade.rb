class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v4.6.0.tar.gz"
  sha256 "fc1f1efdd1d108cd2c2a39e544c0e11a20cf7460bd8abf22104807b28d33ae11"

  bottle do
    cellar :any_skip_relocation
    sha256 "155b46bd6fe2246585b137b7c4d5eb1b2e8bf0467e205aa6eed5d5230a9f3ed4" => :catalina
    sha256 "c57a6a13ca981427f06cde7b316f79423aee34e4f39be3f6a7830e569a6838e4" => :mojave
    sha256 "1d16edb497afd9b047d30895a9ed029acfee42e8329a1ec38256f5e358349a54" => :high_sierra
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
