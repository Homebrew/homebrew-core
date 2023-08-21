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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a86dca0e99ab05358c172347f3d5cb34f58c7a3724335354b43ef99c2c2b95a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1d933af95c13fbf890c3fbacd7cfc982dca97b20487abf93ec1288ad3063778"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "890f3045671e1768caf1a9dddfff37e16d22989942dfc88a5995b5b99d76ea48"
    sha256 cellar: :any_skip_relocation, ventura:        "a8a01a3cc1bd092bc383463651ee4415e481d1df039fd0a4295b13f1db8bdf8e"
    sha256 cellar: :any_skip_relocation, monterey:       "574908e466f82e099256209fcdc234947728c70118f12ebe957d3331f8060ce8"
    sha256 cellar: :any_skip_relocation, big_sur:        "380214bdde3dbdda8e750e610660addbb84a0d52ae13887f4d99888ef1a838fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28e1383aff696f1f89ad7b51073b8a045e73c5185e40954bba89a8e5c871e7ac"
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
