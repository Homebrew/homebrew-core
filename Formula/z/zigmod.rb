class Zigmod < Formula
  desc "Package manager for the Zig programming language"
  homepage "https://nektro.github.io/zigmod/"
  url "https://github.com/nektro/zigmod/archive/refs/tags/r107.tar.gz"
  version "r107"
  sha256 "605717096ebe830591aad10a1dd590bbb0dc2d2ea76fd37840adaeee08fba5d9"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^(r\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "566f26869092260bbad93032711fbfca01d0c4e415d100b488fc3cd4d207f6d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "61bdccd7913c453c2edc27ef7ccc7ed308801908b55ae3893f614a79a613b1e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d1c7323a3e78481e79801d875d5e87b90537daa8a6b6848fa8c7ca5a55abc0eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "520766208b32b76ca67a2eedacd7c01a5d3bc67675aeb88b5b56e896afaccd3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ae5622a497b30880ea2a015fdc59cc6bbcbaab9f10d10fba1f06c7c8d091b5f6"
  end

  depends_on "git" => :build # `zig build fetch` runs `git clone --revision` (git 2.49+)
  depends_on "zig"

  deny_network_access!

  def fetch
    system "zig", "build", "fetch", "-Dtag=#{version}"
  end

  def install
    args = %W[
      -Dtag=#{version}
      -Dstrip=true
    ]

    system "zig", "build", *args, *std_zig_args
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
