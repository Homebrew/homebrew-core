class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/60.8.tar.gz"
  sha256 "c512814e2861cbd44464afb8a7b73c174eff809e93caf6e255a9d9baca3a3483"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7ddc19b3fc04552020ca8fc56598ffc6441493281a03a374618cf3a99fbe65e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2458b06e0fa5434184316218d7c93b1593c513b52123416d2560746a6353650"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "875c321df5e592d8dab7d72f72cabd2b0738282e2049cad77d677dde722b08c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a79b07cd20ed40806e6f2bb653398ff9b1d1c12039ad54e0e05801c6c720dc47"
    sha256 cellar: :any_skip_relocation, ventura:       "9ae299266bf68680341ea0954dbb29bea0d1f7697531b49e4ef97b3078ac1075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "230433d69852a6f84308e646a8e068b64cddec4dbde599b2a398053f730cee74"
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
