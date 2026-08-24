class Zigmod < Formula
  desc "Package manager for the Zig programming language"
  homepage "https://nektro.github.io/zigmod/"
  url "https://github.com/nektro/zigmod/archive/refs/tags/r104.tar.gz"
  version "r104"
  sha256 "ae9d845a67750d5f7fae685768cc3bc9bf6de059b767502ffdd8064c5d8e4c96"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^(r\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24411cf42bf88695a946e7316cbf83ea642e6ad3d9cd448bca43e85ff7516235"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f26bd51f9efcb3fc47df72a9d6c2ee576b0ee270d17dc03148404a8ce07b140"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a233864aea51cfece4e00886b86c88364a008ad4e7703db66c296c7491c9c72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e08b05a5912a0a0435d6414172f53d410caa4bf1b84152802ae39ed153057fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dcdcc22cb83227c174cf3d36d413869e61a4b23a644bdce315d1005e6367150"
  end

  depends_on "zig"

  def install
    args = %W[
      -Dtag=#{version}
      -Dstrip=true
    ]

    # Upstream doesn't use `-Doptimize`, see: https://github.com/nektro/zigmod/pull/109
    system "zig", "build", *args, *std_zig_args.map { |s| s.sub "-Doptimize=", "-Dmode=" }
  end

  test do
    (testpath/"dependency/src").mkpath
    (testpath/"dependency/zigmod.yml").write <<~YAML
      id: 8w9skd2bi3x7vh6z6xcu3taaz1tww2ghbjt5p1e9fyj1pgsu
      name: zigmod-test-dependency
      main: src/lib.zig
      license: MIT
      description: Test zig.mod dependency
      min_zig_version: 0.11.0
      min_zigmod_version: #{version}
      dependencies:
    YAML
    (testpath/"dependency/src/lib.zig").write <<~ZIG
      pub fn message() []const u8 {
        return "Hello from zigmod dependency!";
      }
    ZIG
    system "git", "-C", testpath/"dependency", "init"
    system "git", "-C", testpath/"dependency", "add", "."
    system "git", "-C", testpath/"dependency", "-c", "user.name=Homebrew",
                  "-c", "user.email=brew@test-bot.local", "commit", "-m", "init"

    (testpath/"zigmod.yml").write <<~YAML
      id: 89ujp8gq842x6mzok8feypwze138n2d96zpugw44hcq7406r
      name: zigmod
      main: src/lib.zig
      license: MIT
      description: Test zig.mod
      min_zig_version: 0.11.0
      dependencies:
        - src: git #{testpath}/dependency
    YAML

    (testpath/"src/lib.zig").write <<~ZIG
      const std = @import("std");
      pub fn main() !void {
        std.log.info("Hello, world!");
      }
    ZIG

    system bin/"zigmod", "fetch"
    assert_path_exists testpath/"deps.zig"
    assert_path_exists testpath/"zigmod.lock"

    assert_match version.to_s, shell_output("#{bin}/zigmod version")
  end
end
