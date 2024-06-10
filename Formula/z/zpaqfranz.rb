class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/59.7.tar.gz"
  sha256 "d2b19dfc71d743378727f1c4254f8f3b5b0e1ea59fec7b889e8912822aa4c32d"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc454181fa5658f6ba8ff1c7db8ba492212bea2dddf18b0782c99a6d037711a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "633f68cbe0b76ab1a965dfa3e4edb122608d2340c99330cb1572fb92cb4f0661"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca6a517d418ff2c14db258bcb7ed6f5c4f4250afbc41eeb9644fb06b630bd380"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6038e30fac27ac505367dc6676a8bb6bed39ba7c2ae2deec7c8e248f9d531c4"
    sha256 cellar: :any_skip_relocation, ventura:        "aab73f23cfa5dc497806c2a571b088a5026ddf4794c1fac2f0ce20dca98fe430"
    sha256 cellar: :any_skip_relocation, monterey:       "86425e6b9d0342dc2dc7a50bd53e1358e60529482982a29c6ae0c83c224202c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9fcceac815153e54d336287af4c789c66d718d5079223083f929c9e2a421350"
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
