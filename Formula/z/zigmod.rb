class Zigmod < Formula
  desc "Package manager for the Zig programming language"
  homepage "https://nektro.github.io/zigmod/"
  url "https://github.com/nektro/zigmod/archive/refs/tags/r93.tar.gz"
  sha256 "302162e6ba66ee8abe028b5d61fe1c474ec50eadfb6481dc782702126fddb639"
  license "MIT"

  livecheck do
    url :stable
    regex(/^r(\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "420f7558e02cced834ae9109dfb12b93a864510c582af36d097cbb25a3379fc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ada99291a14a4b050d9021469d4912be19098785d6d557ccfd09f7613dbce43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6dde24eaa99843a68b0f5c59f95c3a7116afd326b315d8a30f519cd6eb099c79"
    sha256 cellar: :any_skip_relocation, sonoma:        "61702ca7b0671790b8598c55957f3cd53b6f215907be3add1f9de06f3da746ad"
    sha256 cellar: :any_skip_relocation, ventura:       "dfd79a1b16483e86d85867b7494952d6a9c05dbc26c0924fd952106370e41500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41a39652f9ed4f90a02280a3064bfa9a16746fda7af518d886280e86dceeb068"
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
