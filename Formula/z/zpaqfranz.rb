class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/63.1.tar.gz"
  sha256 "199d9617eaa184436f5db4c6d981ea133c7d98c056c9dc0be473fb21c570d37d"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "576d0a841ce87a01ad5200f8c14223298143ab4e411c8e61aac0f2e8cc7ac25c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ab9aecd9b412eca9172efd718fa9f53cd25d83539c821acfffbca0f80648281"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f256b6b63974ada222c66699141b21f07015c3f30e2da4a5422a5fb7449e717"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1dff15db9a819e98507efd9c093a63aa82868e07adcee76411d675ef393a25c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b1cab9b08414a26fb52082eb044171577fb7f7ce5dcccad5ffdc7bace645480"
    sha256 cellar: :any_skip_relocation, ventura:       "bc859e0cbb489b071eef576415076cee513822652cc9b4e20edb7a6651b8f7d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cd9d6e8fdde948b18ad5855301fdd057a1598a8fb19f3811f64a4b7fdb2c8b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c2bcd08d4acf718e73ff1aeb7f330760ca1876c9e824481786a2ca36b1abc02"
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
