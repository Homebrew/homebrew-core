class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/60.5.tar.gz"
  sha256 "d74f0f40eeb49eecc0ffaa6670af15976124edf7f2f4ba96cbc50f7c99815a95"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "896ff14e9282f5af016e2395df136f3f0acd8361075636a61b6d7b40e76b11ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "480d97098e4a29f52c0596ddf652019bdacbbd4bc1bc9c122b2e2a8c3bf6da94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "452a6ac134dbb1010f602b15bba80b3d1e64239a0c119a8a63f4b6bd239628b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "31f7c36510d77c3b0ac03e54f3b6c94fca9209fbd85495d1b31811ebc922e429"
    sha256 cellar: :any_skip_relocation, ventura:        "3730a582cd5e278a83b7a61942a7a3fa4f1d4a7be4f3ef47c7df1c5b40cfc1ee"
    sha256 cellar: :any_skip_relocation, monterey:       "2af8f578c5327d68888f6252e7383f47a1cce5503992e8c011cafab5f8e40840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5eb0ea3cbe7a143aa344cecb5f7928096050232ecf2354c39effa1613255687"
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
