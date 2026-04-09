class Zigmod < Formula
  desc "Package manager for the Zig programming language"
  homepage "https://nektro.github.io/zigmod/"
  url "https://github.com/nektro/zigmod/archive/refs/tags/r99.tar.gz"
  sha256 "b2bb91cfae4cb470c6b5e461f6a8bc33b0d4df8a8b0ddf35505ac9bf42b76072"
  license "MIT"

  livecheck do
    url :stable
    regex(/^r(\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcd2ad3392aae6c20b201de6a0ae1885d1d05e6ab2fb1c9166a3c258d92dd1c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72f2899614daf31c4786d3bb3c9df2aac398ff49f150c87c8fc1d80b4f8d6ee7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7fb4c072fbe0055ecdcd5420c8ab54b9fc50fcaa3dfb24c5f6d76326253e278"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae568a5381dbba1ca1dd0e8864cf4cd3d098d5e1b65bdc507706e7bb99e653ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6667190a84c317f48674c5ea1c9d67c7f0c2267d1c407ffc24acafae5c241e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "404076d214fae1b64dcc4f17ec37606fc303fa18f475342933cfd93331817323"
  end

  # Aligned to `zig@0.14` formula. Can be removed if upstream updates to newer Zig.
  deprecate! date: "2026-08-19", because: "does not build with Zig >= 0.15"

  depends_on "pkgconf" => :build
  depends_on "zig@0.14" # https://github.com/nektro/zigmod/issues/113

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
      -Dtag=r#{version}
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
