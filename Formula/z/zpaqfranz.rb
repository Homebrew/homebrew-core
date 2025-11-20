class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/63.6.tar.gz"
  sha256 "1a78d45756d20d9df3e6c7db4ee2b31e8193e4511a3ca739310a180aaebaea28"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2694a1eb1f31e88d780c2549f2d3403aa877f5126dcad45a253e8f93358db9e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3088cebc76769be67511da255f5d0c9289f0040e1e17aae1d03701e932fd567"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33f31afe68fb568069eaf4ab0da903703a643ae3e72c3a414a15347eafb058cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5584810863a379ebe832088580cac3735ba8085375ece48b747e78da3976c03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97e6f54909ec97bdfb700904538161d0a583f86fd04b2ccb420a3885b586bcb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b189a7dc6ba63f68ff27a5820e80616ac5d282fe9162ed3678232d649d3aa80a"
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
