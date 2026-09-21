class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/65.1.tar.gz"
  sha256 "30f38dd31f1f99df2820c0852d8ac35356c8dbf8de8902d8a171987454e7539e"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "09c4e3d404939260a164626ef249f950e86ef6cacf02868217ba2790b62de320"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8c68d796783a8c4d8a1445fc76317e2a60353b15da1d32aed4c3a327c1ad64ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bac4072c0d60264035ef1d31f4cf6bbc591efe388809372146dda6a6133e0433"
    sha256 cellar: :any,                 arm64_linux:       "04da5ffa363d3084020c19644128d254ba9da9ee72166a95d735f3864bccdef2"
    sha256 cellar: :any,                 x86_64_linux:      "7378b8ca9dd7482cd6f3608531c034ec157d210b7be5aedc951587132a3bf473"
  end

  deny_network_access!

  def install
    bin.mkdir

    # JIT only works on Intel (might work on Linux aarch64, but not Apple Silicon)
    ENV.append_to_cflags "-DNOJIT" unless Hardware::CPU.intel?

    system "make", "install", "-f", "NONWINDOWS/Makefile", "BINDIR=#{bin}/#{name}"
    man1.install Utils::Gzip.compress("man/zpaqfranz.1")
  end

  test do
    output = shell_output("#{bin}/zpaqfranz autotest")
    assert_match "ERROR 0", output
  end
end
