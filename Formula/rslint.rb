class Rslint < Formula
  desc "Extremely fast JavaScript and TypeScript linter"
  homepage "https://rslint.org/"
  url "https://github.com/rslint/rslint/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "1f3388c0bedb5bfb4c83f49ab773de91652144cb08327038272ad715cb161a83"
  license "MIT"
  head "https://github.com/rslint/rslint.git", branch: "master"

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
