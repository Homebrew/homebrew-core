class Zigmod < Formula
  desc "Package manager for the Zig programming language"
  homepage "https://nektro.github.io/zigmod/"
  url "https://github.com/nektro/zigmod/archive/refs/tags/r89.tar.gz"
  sha256 "3c53d2c50cfc6d0ecc7d1f326e84f11b9d3ffb4c35bc2ad73ec9c4b4f924eec5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^r(\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2018735989a352dc810333e9fe56e988f8ec6cc04e2f2ef110c423c2e8bc78d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5075953d63bf642db089d7186541b5196dd02a6f874c8df558e2ee6a877dd362"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9db743ebce1eb091fc482a50428f0c81e2750792c7239ab609fde5858a69ae9"
    sha256 cellar: :any_skip_relocation, sonoma:         "5abcc719b5feba7cece3905da953fc78f29168ece9f782d5ef4e8ca2db014984"
    sha256 cellar: :any_skip_relocation, ventura:        "5e9be7c44ff6c9fccd95fe91f6a6d73f1aea774021d3421f68b53dc15330b21b"
    sha256 cellar: :any_skip_relocation, monterey:       "a3e79885e16d0f981998efe8e77528b9f2554178692094753ff82b610ac6fbcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "494a4e835b2f3c9a9fd096b5aee9cdad64c236d1b364f2c0970d832c54b91308"
  end

  depends_on "pkg-config" => :build
  depends_on "zig"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
      -Dtag=#{version}
      -Dmode=ReleaseSafe
      -Dstrip=true
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args
  end

  test do
    (testpath/"zig.mod").write <<~EOS
      id: 89ujp8gq842x6mzok8feypwze138n2d96zpugw44hcq7406r
      name: zigmod
      main: src/lib.zig
      license: MIT
      description: Test zig.mod
      min_zig_version: 0.11.0
      dependencies:
        - src: git https://github.com/nektro/zig-yaml
    EOS

    (testpath/"src/lib.zig").write <<~EOS
      const std = @import("std");
      pub fn main() !void {
        std.log.info("Hello, world!");
      }
    EOS

    system bin/"zigmod", "fetch"
    assert_predicate testpath/"deps.zig", :exist?
    assert_predicate testpath/"zigmod.lock", :exist?

    assert_match version.to_s, shell_output("#{bin}/zigmod version")
  end
end
