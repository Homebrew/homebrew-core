class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/62.2.tar.gz"
  sha256 "12cad71439987af886639be576d936d97c097f505caa4d5ebd5e454ff844610b"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cc7c2e2717ff9f2a9422ca3a6382fec60ad4f043aa27995f9ee175020868afd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9d0ec317388236b384f8e6deedb6962bcaf4f0c7008188189d22ea6d617d60d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e90d2132aeda6d6200a3d20ee50b1bf76ee92ec72b80b7d8d78010516181ef6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3719cbb4ddc90f8847a427391a1c81d219be3ba98d34246390196c0b2cc4a548"
    sha256 cellar: :any_skip_relocation, ventura:       "ebc35c7365a0e8c5099f378efc0ebad074f7ac3224018a017efe230e0266e6ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96b0ad86e6b4e4ace13d7ccd029bcab8c4d138c58b2ba1e69523ee203e387264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaced67567513be07a50c5ba4d6b22fd336652991fd9b1e4134e295fff5f26f5"
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
