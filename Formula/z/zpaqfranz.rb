class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/59.3.tar.gz"
  sha256 "a1e3c6d738050a7b89881d5da39a95a02e04cbadd6e796c4e03267691a185d83"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b4d9d6bf251d665e377d248f8b9f48f807fc2e7d58f0050d34f08b307bdeb52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42dc51eb24362728ff4587e351a46b057f2f5f5ed9e58a2b8611612ca300a1d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e184d6a3bb2cf16b5feebf94740242ce83bcbd0eafc74542bdde289f59d92f8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b51f38139e810bc89e200dcbecda757616748fe050292b1d66fe8c5c2bd1789"
    sha256 cellar: :any_skip_relocation, ventura:        "8981b695f16b19d411aadc7c06bb3e99069f5aa5113616eb7d964c205fca789f"
    sha256 cellar: :any_skip_relocation, monterey:       "ab03b4b961f48a685a72dfedae01067fc9a5846a6f32870ea97e72f98d02f1f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b1e0ca622afeb93837c28d4a635175ee2421b0169206e9e3e9c54f37adf4068"
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
