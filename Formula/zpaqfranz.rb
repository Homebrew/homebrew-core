class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/57.5.tar.gz"
  sha256 "c0ba86c33cb061fea909cfaf629305a46ab712eb4715b0b8ef2e49438055f97e"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0bef53ae17206bed5dce3ec443a1f611157133dd841c984fbcb23ffc3a8545d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e308f03281301a4cb56a6c432c253521f776f61bd40194eafcf50ab06061816"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73b7e69a62b70769cde9407431cf529cab09894c5a7cad7d0fb4fa7213c176a2"
    sha256 cellar: :any_skip_relocation, ventura:        "296d7c6c32febf879490a5b854cfd266746100f38603ce91aada3e13dfa231b8"
    sha256 cellar: :any_skip_relocation, monterey:       "5a7078257b14dae4d22d4d563bcb983c580a28718ba068cc485cfb2bd21f137b"
    sha256 cellar: :any_skip_relocation, big_sur:        "13ed30b4cf87c0f341c2c88d7b105c9610c9e60e9c6524d8413f5650eff4339b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ada8e2725825db710b34e3bd86bf4b9231071bfb61b774e5ea4bbcf504bfcf4c"
  end

  # Use a C++ compiler instead of a C compiler.
  # Reported at: https://github.com/fcorbelli/zpaqfranz/pull/51
  patch do
    url "https://github.com/fcorbelli/zpaqfranz/commit/298e496647373570b54307f4d4130bbd915ba9f6.patch?full_index=1"
    sha256 "ad02acdf3922946f09203bca4e0b926c3ea15953f04ae759e9ee8efc1cebf8d7"
  end
  patch do
    url "https://github.com/fcorbelli/zpaqfranz/commit/4cc32b6ffa599e3b9528c4c97d52b6ebcc697efa.patch?full_index=1"
    sha256 "a86ed4ff7f223e65a6720438aa6c2d2f3bc42d8959ee827e95d1798d9d8b10c0"
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
