class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v5.0.0.tar.gz"
  sha256 "fc3ae25c550b66270457c11778bddcbb3b664638f5181f388262bf40e8811124"

  bottle do
    cellar :any_skip_relocation
    sha256 "890d5539d01dfbb613f4d90c9da91568752a3da0a3f666c3168f2978ca647714" => :catalina
    sha256 "3633ddc2bd8a972bac3b5edb3bea9b422eaa0985a8757a0d2d682606039557fb" => :mojave
    sha256 "59ac1dc96bfc7d92200307f4a547fbce85baffeb429f2af90782f30c766ccec6" => :high_sierra
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
