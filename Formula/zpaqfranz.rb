class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/58.4.tar.gz"
  sha256 "2b9410768128dab541e7db52c36a6c48e1630c32e10f2388368a94d9143e9fdc"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edd761ec526f2ef5b390b8be963236994d4f9ca0ddf1e7746c10e92c8c1b3a0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b3871af032bea09f55ab6c1a4ea8d08008eb30a074fb92fe26d2c7aacd2afe0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a2d92bce3fa8d9bc6da9f855a447555efca71c3c604d2ba71e57176175583f3"
    sha256 cellar: :any_skip_relocation, ventura:        "38fda97c4ff2583c9f426babdb83f944f91601cdb3bc7820f09de6e71b799838"
    sha256 cellar: :any_skip_relocation, monterey:       "85648624b509b98e80367915bfbed175283adb31311d93070098254c88d463b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d18b04c0617659770462ef19bc8d18ae13f20b70edfd3b17ba0bc09800d550c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac39fba1ef92033b7262499e70f5297851c6ad27ba557fd06e925fcba71e5692"
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
