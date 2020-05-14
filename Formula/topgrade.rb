class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v4.5.0.tar.gz"
  sha256 "92ec9e1b418c6d93894c5a356a02c9cb9e8426a902dd6d253eb844925110a2ed"

  bottle do
    cellar :any_skip_relocation
    sha256 "256bc55768ba58292084214ffa427402019411b9f197fe27aca71a67f3edbc91" => :catalina
    sha256 "cedadf3f8b434666395ede61f46f1e512d03cbd2c7ac98203c50db7e5e9c18f0" => :mojave
    sha256 "cf3cacc580950f5b43d277444842d3c05aeeb886ed61163e2228511b00d023f7" => :high_sierra
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
