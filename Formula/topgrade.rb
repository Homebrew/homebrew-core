class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v7.1.0.tar.gz"
  sha256 "db8a2777f0a1c3e59012936d3edb5a54d378a2be036604590557d6e3affde8d8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5fbcaf579aa1f3b26fec2fd26b4921610c97a26c787f1140a6842e9c740bebab"
    sha256 cellar: :any_skip_relocation, big_sur:       "9a4220a5a6d3623900ec1f40c779700f85b7f64f60f261adb9e5618b8a0bf799"
    sha256 cellar: :any_skip_relocation, catalina:      "e8d0ca4a5deec0f9b784dd5d448617acd1da26d02ebb91d665cb91a070c35063"
    sha256 cellar: :any_skip_relocation, mojave:        "6eea95176cefa5c10f63d509e43c708f15ee03cda4b16fcfc59e746bf7e35b2b"
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
    refute_match(/\sSelf update\s/, output)
  end
end
