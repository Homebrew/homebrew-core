class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/58.3.tar.gz"
  sha256 "50d279d19bd9dca464f766661782ec1a2f3963f3e72029e6ae89c9903072a29c"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0eb64ad8d65bd1dc45e4f2d2e51beb50368df16d41cc2a0e095d2a44afb3228"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1493c0d36610dbf816817f0d6c17d44fdd918d59bce62f5424f30a0aaa669a1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b5c645a141b52f85d9805c64c51fcd96f489c3b56abf560dd00c99afad5dd93"
    sha256 cellar: :any_skip_relocation, ventura:        "79918c61df3a3066bd0fbe92245dad32226fb15ef939bbfb8e06ba1aa0ebd16c"
    sha256 cellar: :any_skip_relocation, monterey:       "9fefbadfe054ecf2dff5ec1be070cdb177eb85085913f3492fc3e0f71680f754"
    sha256 cellar: :any_skip_relocation, big_sur:        "9542d5d08d46d429f68c25eee6b3e41a09db76555556cd8ed9a8a698a50e01d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a856c7b701314944787ac58eaf7f7718fb237015380e92b47042aec7de4c43e2"
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
