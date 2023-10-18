class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/58.10.tar.gz"
  sha256 "977fc9d11c4be7498fbba3e0ba89f22085c51267afa754096ecab86a90ef0643"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3e3c5c9c072fffd902b1cb04a99d9f9992c46bb17ddcbe5745b0fbbc386da8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "993c905699859471ee6e5afa02b852160c90e14a10c73f8c9e15e8b36c588e56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95154cc7ec10c18a9dae5f5c2f3472448e5db24f932d1a0b6acbfa2c28ba15b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "baac207eb0a415cd61e214eff6cd64cebc8e0c3ac7d2786c5d2d98454f2a3909"
    sha256 cellar: :any_skip_relocation, ventura:        "520741761bec75092365ab3a3990b40d8a7c66e94ccff24169802c2897918d6e"
    sha256 cellar: :any_skip_relocation, monterey:       "e45faf397f0ec0f95d9c6b7a72fbe6ef5c23d5eb3c20affa87fc3a790edb3e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e089ab86a56c13993e495687d4a505c34ae9432bcc084ef11547801738e9644c"
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
