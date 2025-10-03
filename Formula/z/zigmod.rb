class Zigmod < Formula
  desc "Package manager for the Zig programming language"
  homepage "https://nektro.github.io/zigmod/"
  url "https://github.com/nektro/zigmod/archive/refs/tags/r98.tar.gz"
  sha256 "a7fc24e2784bf35660e7736b92f63049cbd6c98693724c930a1755284c20cabc"
  license "MIT"

  livecheck do
    url :stable
    regex(/^r(\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e8ed85856fc8f7d8947e41faa35e63bc8f63cd2b8cac1a09ad349107ef663f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ff38379c6544b1c8d59e7f8859a8b0f525e28641daf2169cc678dfadf7e08da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81e04b9abb26106139fc02dd432eb6414765fb628fcc94cb438eca21d546b300"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "452789666788c8fc49734e0b45e2387766129a7df577680375419299f45a1b23"
    sha256 cellar: :any_skip_relocation, sonoma:        "59088c6d7e3d66a9831c094a37a2f5cef94f41efdb795c32ff28b158f470a66f"
    sha256 cellar: :any_skip_relocation, ventura:       "1a50f4a916744e595d706c2981e2de16945ecc0b2b783d98fde78a39bc34f16e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "321a231d3ff12fe33ad5fc4056b9e006d16e53e47c8a7d7ac7f0314eaaa87310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e666d0c5fe0d8de4c76617fd9dbf0584470919b89946b730f637b303ef45ed00"
  end

  depends_on "pkgconf" => :build
  depends_on "zig@0.14"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
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
