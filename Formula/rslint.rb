class Rslint < Formula
  desc "Extremely fast JavaScript and TypeScript linter"
  homepage "https://rslint.org/"
  url "https://github.com/rslint/rslint/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "1f3388c0bedb5bfb4c83f49ab773de91652144cb08327038272ad715cb161a83"
  license "MIT"
  head "https://github.com/rslint/rslint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c31bc15e61ed4cf42203a3e658c1eb71b3d806b4babf99e683e9f365fcedccb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f196a45f40c69b3dbdc20adc1255301306ba98b016e397901bae778f2a6cb04"
    sha256 cellar: :any_skip_relocation, monterey:       "7c51e40ac4683471f768d958bf5fe2375d226534395b2bc882f1060138c442e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1fed3b6b5f370f98cacb49bae2275d20a1e3b96615c0433098c047e98648c4e"
    sha256 cellar: :any_skip_relocation, catalina:       "d4343b248401217eee1ae79f9c8125f753fced9400810eff170e7ff902f5c92a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94c0c4400342ef622293d652665f592894fc472810efb11b94526b80373d75e0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rslint_cli")
  end

  test do
    # https://rslint.org/rules/errors/no-empty.html#invalid-code-examples
    (testpath/"no-empty.js").write("{}")
    output = shell_output("#{bin}/rslint no-empty.js 2>&1", 1)
    assert_match "1 fail, 0 warn, 0 success", output
    assert_match "empty block statements are not allowed", output
  end
end
