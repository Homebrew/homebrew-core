class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/63.4.tar.gz"
  sha256 "34ac95edded62fe0211fc856d78bbae94cd874a2121baa3397dc281c88177f2e"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c9f22690d4a5c20946f60d1a1365399de4409660bd32cc24f5cc1b22dacb55d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db9791a2c27fc89ae7d3182664d3c6271275a0d92e0a880bf7d209533a86be74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c98f6bd547ae6f6fec6ea76d3fff5590e8e9f0fe2a1720145a9dde94a4c037d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0aa1111266828a32589003fbaa9a33cf9a585275da75aa51f18cfdfa9f7e2137"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe300cc29a69c5bf593160ac60cb8f5f96f7da59ed16b299d599f01cfa4e707b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfe5a7ca99258876204f3cbb4647831983dd02644108443543b8731f0d0b2a56"
  end

  def install
    bin.mkdir

    # JIT only works on Intel (might work on Linux aarch64, but not Apple Silicon)
    ENV.append_to_cflags "-DNOJIT" unless Hardware::CPU.intel?

    system "make", "install", "-f", "NONWINDOWS/Makefile", "BINDIR=#{bin}/#{name}"
    man1.install Utils::Gzip.compress("man/zpaqfranz.1")
  end

  test do
    system bin/"zpaqfranz", "autotest", "-to", testpath/"archive"
    system bin/"zpaqfranz", "extract", testpath/"archive/sha256.zpaq", "-to", testpath/"out/"
    testpath.glob("out/*").each do |path|
      assert_equal path.basename.to_s.downcase, Digest::SHA256.hexdigest(path.read)
    end
  end
end
