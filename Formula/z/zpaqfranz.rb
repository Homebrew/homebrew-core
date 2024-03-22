class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/59.2.tar.gz"
  sha256 "7d649549972c153a4e5f0c3e04c63fbdfa737f722439a26fe90ff789f10d0cca"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13b73ee7112435680e3f82a5579127010df2ff152bb7aa19f69c0a530b291d9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ceefd29f30f98ac08602b42358a68c0356435c713f804149a11a1853bd0a83c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c218202f729bb60845d8074f0d6ee95a9943c08fdf490a8dec388875402e69f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "8970407cf4ab40c47705b0d0a98861e9d712ea4344fc591f137ceb37760523e0"
    sha256 cellar: :any_skip_relocation, ventura:        "7a01f8bfd72d9c00dfdae1286923e010f4a83594687067488469612a8c492562"
    sha256 cellar: :any_skip_relocation, monterey:       "2cf98df87f20849f63433275579399b2d8de6111780afa9f8217af6300d82c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7173d013726ddd7415b02e144d9b3fc8420a077ce49f41e87aae33daf41c1a9d"
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
