class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v5.1.0.tar.gz"
  sha256 "39c667e868715a79b1904326709856ea3b1724200f471fb4d4c09b67c959a998"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ade698b319a84f0ed4a950d6e38be44aefaf25225ee65c08a76a2b36ead02552" => :catalina
    sha256 "cc8d156f801bd11d386a658275a2ad78654cec7277327b60f30306ffc98c2e2f" => :mojave
    sha256 "3deb97d3ac5cb81feaca77a201b0375810e44d85fcb04828f088197acc998c77" => :high_sierra
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
