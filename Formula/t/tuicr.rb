class Tuicr < Formula
  desc "Code review TUI with vim keybindings"
  homepage "https://tuicr.dev/"
  url "https://github.com/agavra/tuicr/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "420f72b7ffc6e40db50383719dbec162fa712130c7a7d83c21cd07d504dd59e7"
  license "MIT"
  head "https://github.com/agavra/tuicr.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cc27030a5efe726a31251f8c69412c31e455361cb3d11279181b861342e823a6"
    sha256 cellar: :any, arm64_tahoe:       "2a033ea1ef6762ed51b652243ed8481fec50243155706f81e36032ef47b2d720"
    sha256 cellar: :any, arm64_sequoia:     "1c3eac8368193ac30d21066b7325895b644fb0328529247a5628aaa3c80994a3"
    sha256 cellar: :any, arm64_linux:       "c42dd00dc469526645153f0154b49362a187a58713cc0dd7565bc2d848170c3c"
    sha256 cellar: :any, x86_64_linux:      "edcadff5e6d54cec4030acfa3a58f65f14e469b4f2493e124819d55f50b80d73"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "test"
    system "git", "config", "user.email", "test@example.com"
    (testpath/"test.txt").write("hello world\n")
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "Initial commit"

    assert_equal "[]\n", shell_output("#{bin}/tuicr review list --all")
  end
end
