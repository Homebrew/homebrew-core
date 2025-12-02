class Rslint < Formula
  desc "Extremely fast JavaScript and TypeScript linter"
  homepage "https://rslint.org/"
  url "https://github.com/rslint/rslint/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "1f3388c0bedb5bfb4c83f49ab773de91652144cb08327038272ad715cb161a83"
  license "MIT"
  head "https://github.com/rslint/rslint.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a889ed0f08b3102adb969159e71ba2d28aa7c40b1809c5fa10d7d57350e9731f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "063ceea1423e7a6c428f7d9c517c64a773eb5a0ffac97c55a45558081aa93d9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5bba58ac05e2c259b3d2e135e5ec12afbea7d67b0b48a892d48554883c65e66"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5c91e6d84fd85d4d8914caea6d4d261a514ce5c4bfa722d423f2bb78615c402"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "464a3bdc1181ddc042da940b4ed478ab546c5f62975a767f4494bea2b80407c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e037bb0d096c7f58a2f36fa404af706c0a0d5814eb6cf659b30690604b15e9b8"
  end

  depends_on "rust" => :build

  # Fix to error: implicit autoref creates a reference to the dereference of a raw pointer
  # PR ref: https://github.com/rslint/rslint/pull/165
  patch do
    url "https://github.com/rslint/rslint/commit/1ceaa3a78d591599a5fe30f702bdb3dae1004f70.patch?full_index=1"
    sha256 "31186aec32f3a587f6401e2610ffa0dec2b37adc1bc4d9a88f816d87f57aa5a4"
  end

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
