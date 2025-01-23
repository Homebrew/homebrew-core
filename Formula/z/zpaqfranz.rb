class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/60.10.tar.gz"
  sha256 "3482b73f0ee4d5c3cf24fef43cc98f0456294226de9babd5104f8f58f3ae57de"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "225ce21420c58e318a41c9f7932c38174d296af682871c98be0b0acaaf0548e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03dc8b79ac8a1907328b01f7bfb6de7d4e6131c7314a14b6c173d124674407be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "777eeb89f6fa94ebb2de6fb44498686e4a9ffbea2ff9590470cf613f1f70ebcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b40ab61f8230945b830128b11c08a05a3dcc3db58351417c70b5e05fdfed853f"
    sha256 cellar: :any_skip_relocation, ventura:       "05932448aa3c493e227f951f3ce55409989805777d915ed1eaf9d31b74e3e87b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5a839fa9b0a5c8edfb844acd7626c6dfe2c7033e8af2962eeb795aa56e8869c"
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
