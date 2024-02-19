class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/59.1.tar.gz"
  sha256 "64fda2ce97078a218ea935ab5a44fb95808fbe6a820306d8c8eb0fe2a24b4f6b"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8620cf977e069471ec6050bd68414b77ea375492eb0025aaf101ccf477034283"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e7f30d2e4689f9fa2bbc8ea426c9ec58417cef945bca1398a3e5cc2b260df8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc1fbdb067ec0fecf70bcf90e62813b1a0927f4075b7148e6a48b8850f1742d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "9047084488dca40bcdd63ed8e80d8d3ee58d2a49c788a2ed0dfd6918c4c4a829"
    sha256 cellar: :any_skip_relocation, ventura:        "91b40eda869f5648387e16e4ba5c5e57871f7b8131d50c93cea099649f199434"
    sha256 cellar: :any_skip_relocation, monterey:       "63b9c7163c8e0e4d31c044287ae40951ade9ad7b349d05cb5f6fc898bb2e48d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55e978fe4b15404edd90867eb90a84d353beaceb183c4312d907adb1d69fdcf9"
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
