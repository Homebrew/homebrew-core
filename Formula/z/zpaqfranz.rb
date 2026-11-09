class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/65.19.tar.gz"
  sha256 "0c97c26d34ae5437e30ed528607d0b47adb2685b40b6d8883c94ea24c81adea8"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26efab7afe01b68ec705a68a32cb2c5578180875bac677eb29d0381b21a7e6c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1db88e848a2559cf41c3dcf4924ef4705638fa70e0e560569a4371a6615ee9fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "43a3db68bb916dd84ca9d2a9170ee77c13d04b3dc62b5f6765db1f7a7f913ecf"
    sha256 cellar: :any,                 arm64_linux:       "daf5636962b9cf52bce38b45765c5274fe50b62895ec94b46290e588d990ffad"
    sha256 cellar: :any,                 x86_64_linux:      "c915f80319867b1734e46dd2a881f8b00ebb1925b524216eebde833e03d35313"
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
