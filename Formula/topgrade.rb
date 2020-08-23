class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v5.6.0.tar.gz"
  sha256 "8cf21d579ecd7be290f307b8dd4a72b7bcff6b24463b1663c6ee754f0f17d6a0"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b8b9a08993d665ce701cc5c1925cdf0e0b6a7f6f5bc73a9a7b7e480feea4d82" => :catalina
    sha256 "28b73442f0fabcc4ecc2837c6e75fd664d9d961f99904eb06cff1c38cbd3677a" => :mojave
    sha256 "09cf0fd7d79cb026c183d6337a6ec69595e7e467c15875d97b3515585ec4a9b5" => :high_sierra
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
