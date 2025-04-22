class Zigmod < Formula
  desc "Package manager for the Zig programming language"
  homepage "https://nektro.github.io/zigmod/"
  url "https://github.com/nektro/zigmod/archive/refs/tags/r94.tar.gz"
  sha256 "139e990afccff7ab33b864ea479dad1217c293355583c8ad864571f77764b7a2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^r(\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5bfae8b75eb13ff8c0d4e2b0595ecae4c6d32ad969d098612919f5dcfda257d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22ecae4483dd909ac23fbb018e7c10da835f21c415627674e4999f3306c8452f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e84ecb51e81353a55855dcb6c8411572fa05730c8a70a7bb57411ffc9a33d5ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "51afc652ad9869c5fa57c388cc9c9e970444db44c476992bf5e15b23e22a43ac"
    sha256 cellar: :any_skip_relocation, ventura:       "91066de4ef3b96479f7b19328b2ff76ffd3c8275a97d41c4e299a5983f1c1607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4986c6e8b71077323fb1879e29c69245330811be31240a8b12bc4926f9b81a1b"
  end

  depends_on "pkgconf" => :build
  depends_on "zig"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    # do not use std_zig_args
    # https://github.com/nektro/zigmod/pull/109
    args = %W[
      --prefix #{prefix}
      -Dtag=#{version}
      -Dmode=ReleaseSafe
      -Dstrip=true
      -fno-rosetta
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args
  end

  test do
    (testpath/"zigmod.yml").write <<~YAML
      id: 89ujp8gq842x6mzok8feypwze138n2d96zpugw44hcq7406r
      name: zigmod
      main: src/lib.zig
      license: MIT
      description: Test zig.mod
      min_zig_version: 0.11.0
      dependencies:
        - src: git https://github.com/nektro/zig-yaml
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
