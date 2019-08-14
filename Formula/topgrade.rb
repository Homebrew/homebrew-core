class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v2.7.1.tar.gz"
  sha256 "c12e9fe65f35c6ef6683e7f2978b034caf12e7c6c58254e479ba0c0e9b3d02d7"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b41e709726c8d23f965726d5cbce8ab064739204ca417f766318b73b8439e44" => :mojave
    sha256 "40a2495d231f4a0f03aaa910a6784ffdafcedeb7fe8288ccf54e46c8c7667f47" => :high_sierra
    sha256 "da6151b92139020e4219133fa9eed19361810b642761f9130b1ab72b825fcbb7" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
