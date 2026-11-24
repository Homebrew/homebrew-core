class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/65.23.tar.gz"
  sha256 "f74e5b6a0612e91ae183756f31aa997125bf7d7113c71ec01fc50843f9c993da"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "3bda26c91e1760ce372b3b257f53f15cfed2582303b12ca5f82fef19331ac50b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f0a6d25b04c1ce7eb5f7e23b28a840a65ddcda15ea82ef7f23f348fd385f5fe6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cd77444ce859295face5dc7949e6f3f547505d89b6517d96a3281e11ebf87f7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1311f6d8ad8308d5691d4220d8bd60ed45aaef0e229766fb0c08e3ce084ada8e"
    sha256 cellar: :any,                 arm64_linux:       "39ea818855373eff4e1a351c2e13c22a9262eecda9eec41383ff3b4ab7eb7fe7"
    sha256 cellar: :any,                 x86_64_linux:      "60157647ea23c112156a0b822c709160f819c1269a2a136747ef6be25c761e39"
  end

  deny_network_access!

  def install
    bin.mkdir

    # JIT only works on Intel (might work on Linux aarch64, but not Apple Silicon)
    ENV.append_to_cflags "-DNOJIT" unless Hardware::CPU.intel?

    system "make", "install", "-f", "NONWINDOWS/Makefile", "PREFIX=#{prefix}"
    man1.install Utils::Gzip.compress("man/zpaqfranz.1")
  end

  test do
    output = shell_output("#{bin}/zpaqfranz autotest")
    assert_match "ERROR 0", output
  end
end
