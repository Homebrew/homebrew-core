class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/60.7.tar.gz"
  sha256 "d760a22cf907541b2c63b2a66ad71133e39fec0a4ec54ef67f1b3a29cea62554"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3afb5c4cd0cd478a0f7577a355f50806e2fea4b803cc8a3d55733542978f68a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a05f3176ae33065c09e65ca1bba790a42b240b251640fa1ad5b7ee7a74a3e9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5554d5b6c5cb6f9848d304ab57a6d09d0f4a83172d4c2940014c7c932338275d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c65cdfd64ca855917c00a2114bb0f68d8098845368722eeb30617aee63e98234"
    sha256 cellar: :any_skip_relocation, ventura:       "12bb7495683d70f4ea78c62f1d17a94ae8709de20ac8baae430d5cf26a4337e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8e81353e1908c6978b2a6fcef5f14fd3497ed2d479a4799f5bf72171ffb6dd3"
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
