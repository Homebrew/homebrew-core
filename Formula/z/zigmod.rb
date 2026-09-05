class Zigmod < Formula
  desc "Package manager for the Zig programming language"
  homepage "https://nektro.github.io/zigmod/"
  url "https://github.com/nektro/zigmod/archive/refs/tags/r105.tar.gz"
  version "r105"
  sha256 "b88a477602b63ce4f013701369ab4356ff91830915021443aa74380df474c1b3"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^(r\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f37c874532fafe5bebe759e1d780063e8a8e1203ab0eab92397c4e51e7911bc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc17ae0d9a279c31fc35588761117b8533f3e03c05190e7f05d8823d29f074bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3a25a78f5a61d2d5e1e7b828bd5532adf9e13c51b35dc78512d907cecb3ae32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b614aa01d3a6253b86ad4c066fc24902db2e6db296d6277e899de656d5ea9d67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "456c7505eecfd41737459a8cf5d4f3f2f4a745a9e71421b6bda86fa515320e55"
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
