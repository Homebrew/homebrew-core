class Zigmod < Formula
  desc "Package manager for the Zig programming language"
  homepage "https://nektro.github.io/zigmod/"
  url "https://github.com/nektro/zigmod/archive/refs/tags/r103.tar.gz"
  sha256 "965bd1aacbe4fee5c3dbbe0715d40f5b6a6413065bf5dc0385ba1ba1acc6c2e2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^r(\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ef437f4e9b2f69a1be4adaa651df67f580cfd84f34fe9efc3f20001361e303e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84e496ca7896cdd75e684c8640aa3fed836274cb3dfb8d02454a03910d98b7ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa5303dd5bb7b26327a14ae30734651f0904d1247f5aa18458bd4a737ad75fe2"
    sha256 cellar: :any_skip_relocation, sonoma:        "018603bd82921507439ac811e64a345a812d8c8ec1c70244372b91e791c25806"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49762f0cd3b574d5b33a269347537dc5636c94c4dd61f5b7a6c2ea1b234863f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cc6fc70bf0c8af0294cbe4319ad37118c9ebe83c9f4ec940961d6b04c03b625"
  end

  depends_on "pkgconf" => :build
  depends_on "zig@0.15"

  def install
    # Avoid zig-nfs mkdirat failure when creating absolute cache paths on macOS x86_64.
    inreplace "src/common.zig", "try nfs.cwd().makePath(cachepath);",
                                "try std.fs.cwd().makePath(cachepath);"

    args = %W[
      -Dtag=r#{version}
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
