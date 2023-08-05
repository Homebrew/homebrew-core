class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/58.8.tar.gz"
  sha256 "26e915a2c313675805714efed04a1082526ecbb02ea792c60b53e31d1a8bd402"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16ecb22fdc5fdb50c0b2607d1b94959d1e6c9694df1c98ecb6565cd2555feb84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f71b9ec15f8b0be98faa465331eb218a535b1dab96755a1fdbced4bffe074070"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa24b66280742dcfa0c44aea3c372832332acaae7358385c84dac45507754820"
    sha256 cellar: :any_skip_relocation, ventura:        "efc6daa7afc7f0f939666ab23daab1a800a7dc6d3e1b7146ee2bde1719aec32d"
    sha256 cellar: :any_skip_relocation, monterey:       "78a3cb0a7e979ef95fe47be55da9e56542906c9ca90d39c5530e815bd1e70e59"
    sha256 cellar: :any_skip_relocation, big_sur:        "f22f0b5bb51007627a0637059d8acc978a34df45377728bcc66f17fe50c24baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66bfa1333f274f5e7141939a6503823cc6e0daa3a2c81db11df242462e0c97dd"
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
