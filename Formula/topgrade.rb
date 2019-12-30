class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v3.6.0.tar.gz"
  sha256 "3dd12182e513268e5c76e3ca61245ace582de505f506d38d70f15f758f73ce02"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6e5234510e103565be1b855db902758572b7c3c979bd96c71128da3af7561e9" => :catalina
    sha256 "00588647491a32a21b3953278f5ea9e084beb91c48d2c626925920e008ec8872" => :mojave
    sha256 "72c1363ad40d5eb222aef473a092ad378c743eef37411590acc1b504a8ad7a7d" => :high_sierra
  end

  depends_on "rust" => :build

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
