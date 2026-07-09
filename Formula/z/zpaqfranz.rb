class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/64.8.tar.gz"
  sha256 "051b903b34bbdd98af2bc94558119f48b81bfa382a3ea8c507788f0751ddeda4"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fd1a25bc69e290ce43891bc84094c1957f269c81c5c0c1becd86cd27c2a5ac7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3587224af19043dab95664ed1177c522b0b48aa07f4112aec39fe26144d86e13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da0fc868b5f9d331f7de9bfd26db91237b60addbff90a6be982320e85a1dc483"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6b9e24c6222392d2aa62e1a5ca59a7804f45f769acd5df039a899063e59cbc5"
    sha256 cellar: :any,                 arm64_linux:   "8257c88ac8c28d293bf9e33a6ab7976539df225965c869188c2b7eb242f55319"
    sha256 cellar: :any,                 x86_64_linux:  "24a956caa2761b5594b378f38d4dde946b681e23c1376925966c9772d2775520"
  end

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
