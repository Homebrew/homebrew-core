class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/63.3.tar.gz"
  sha256 "07e70253ed1fd773466a13a7b6834129d853212740b99f07249a72d97e6c0abd"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee40f95f457a040dc35b1a851c7a5adf1893cc02a7ab98d95d70ac558ea0d1e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bd153a8af8a81864114630793bf03064a78a40168b26e12dbda31626357c4ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52d3b046d49bc37011c3d6766d2c311b4da265ee4f4f767088f039f88bd6f9ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f4e25e0c04e0d72996da522d42021d4e47106de8f5db2eebf348cc364cce620"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "585f8f092673f37fd7efa6683ab0023cb73238662d57aa77aeb41a032a0a5fc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de7c06ea0b66b57f12d653b5f3ffa136a454b84c281682346d84c3337e6ae87d"
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
