class Zigmod < Formula
  desc "Package manager for the Zig programming language"
  homepage "https://nektro.github.io/zigmod/"
  url "https://github.com/nektro/zigmod/archive/refs/tags/r92.tar.gz"
  sha256 "04f37e09d722c3e23236eebd1f9e5789f1b601bd8763aa6fd2a818a2eb3d9e17"
  license "MIT"

  livecheck do
    url :stable
    regex(/^r(\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "184ef826dd28530282a1c36f20af008b5fb585f9fe93045852b951b6bf21964e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2df959c37b381d5e86591e524e1436c34e08a02b500d65263275d70e37d7826"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4f82b78fe59aedb5032c1533b4ed06e0a47371fc99e8f603d1bc2e88c744a7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24cfea13595d29638d26ae4fcaa44927b7d8110c4eeff3167ec545f9722f370b"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c92b51115a4d517aeccc86498c53f7539cbef96947641a4b743f710f29439f8"
    sha256 cellar: :any_skip_relocation, ventura:        "e806121aa5f08d5861fc53b5861a17fc0bab594eabc0022b8b7052a7c713ae3f"
    sha256 cellar: :any_skip_relocation, monterey:       "68b7d2fec5703629d4beee47c2c620a676b56eddb8e46129686267b86a025474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2e136103711512118cc29a116c2c4b5846570a0f0d28c698aabd9f3121f15a8"
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
