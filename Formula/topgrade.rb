class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v5.9.0.tar.gz"
  sha256 "f7b79aa1819f9f7eef8b02cccb78f7e218b8e9581bcc060af8e4fd16c626b2d7"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "639f88840d31ca19389da3237d1d8f638f1ec13f02804733c8cc7afdae5dec8a" => :catalina
    sha256 "c332e0903168ec1bf2ba9960846f9bc95aeec4587b632a2cba1ac96d55177d00" => :mojave
    sha256 "313a803b4bc0b14c4bf6d5f0cb61f4feb7c18291365ff3e817c7feb266bff476" => :high_sierra
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
