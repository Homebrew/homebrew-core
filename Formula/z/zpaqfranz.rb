class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/58.9.tar.gz"
  sha256 "f681e0cb2ad19b862f953a3c7e469cc1b0222b8c9951b48fe979c3ce41bd4656"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8efaf03aae1b4f9ecbd881b4f3f2ff4af45586c2db072fb8d0f14c8fd214c0a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38ecf107e6c51600fbc9dde3ffac19a7e80e8e0c08b2519dc6976fcf3f13b04b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95351e0f6184b02b1b975ef65aa96be51f9d7f1cc58a32d60e910fb2b87f7469"
    sha256 cellar: :any_skip_relocation, ventura:        "520c3af19894d8b5c8b37e9bf25297419622887a3e06a23398e1bfcc0a15f375"
    sha256 cellar: :any_skip_relocation, monterey:       "c4581f1ed5f2dc49ff171cbb613171f0c8b9bb147b6aa4530695fdfe669c5520"
    sha256 cellar: :any_skip_relocation, big_sur:        "2fd701f148c3049300586d483c0d170c1dd0e596c5658d6ee25f027c815a03bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2df8d5630d1bde406628811527a2c1067e283ccc8ce0b326ec3e94061c2d7b50"
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
