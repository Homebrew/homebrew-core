class Zigmod < Formula
  desc "Package manager for the Zig programming language"
  homepage "https://nektro.github.io/zigmod/"
  url "https://github.com/nektro/zigmod/archive/refs/tags/r90.tar.gz"
  sha256 "e07fb33cfa36fb67de5da8ab0973c71c59cb3ec2ab2733964e1c6568ee997a92"
  license "MIT"

  livecheck do
    url :stable
    regex(/^r(\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c06cde3f3854d8a320a6093a6e547a3b5cab2d57c18c73c8c2dd98e56e894649"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5a65ea349d46fd78d146d84d33a46aef57daf381636082ec6fb7681f31e092e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f798938558b9ead84459c503943d29c218acf022df484bfd62fc7c0d5a246ce4"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf32539425045aec4fdd2d6b561e72fb1931f4de46b7f0258ce6ef6d70110d80"
    sha256 cellar: :any_skip_relocation, ventura:        "fe7ed9e210f6521f19dc6b953c9a9dfed36a52b1bebfc5a22932f890ba74f938"
    sha256 cellar: :any_skip_relocation, monterey:       "b119fd76f44d267616ffa8ee856d35f8ded6f0acadb084acc6d1560d1ce797de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bca3fae00caa75782e70e97067dd6e7b66ee0c8b2a13d9590965f8376475c16b"
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
