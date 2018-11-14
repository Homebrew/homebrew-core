class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  head "https://github.com/upx/upx.git", :branch => "devel"

  stable do
    url "https://github.com/upx/upx/archive/v3.95.tar.gz"
    sha256 "fdb79c8238360115770e9c13bdaeb48da6fb09c813b0a461c5f9faee176d6fb9"

    # This can be removed, along with the two patches, when switching back to
    # the release tarball rather than the archive tarball. This should be
    # done on the next stable release.
    resource "lzma-sdk" do
      url "https://github.com/upx/upx-lzma-sdk/archive/v3.95.tar.gz"
      sha256 "4932ed7b79cf47aa91fe737c068f74553e17033161c7e7e532e4b967f02f1557"
    end

    # Patch required due to 3.95 MacOS bug https://github.com/upx/upx/issues/218
    # and ought to be included in the next release
    patch do
      url "https://github.com/upx/upx/commit/0dac6b7be3339ac73051d40ed4d268cd2bb0dc7c.patch?full_index=1"
      sha256 "957de8bab55bb71156a1ae59fa66c67636acd265a4c6fa43d12e8793bafebb22"
    end

    # https://github.com/Homebrew/homebrew-core/pull/31846#issuecomment-419750313
    patch do
      url "https://github.com/upx/upx/commit/9bb6854e642a2505102b9d3f9ec8535ec8ab6d9c.patch?full_index=1"
      sha256 "f525a574b65e6484f0eb29e2a37d5df58da85b121adec06271b19ed5f4cc49b4"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b54c2ee46e440481f780d3e6abb7cb3c1b8fe1e19de5b34dec4964d5a3c9f444" => :mojave
    sha256 "9c9c64af53571828b5315dc247885f6f14dc250088d24d2e22c8ec431102b1c4" => :high_sierra
    sha256 "21086139ffa7f4d7012f046182a04baebb7afc0bb434f5a59f5636875389afbb" => :sierra
    sha256 "7410cdbfca2b1d0fa0fe58abd4b0aa22c158d77667b7aa9b04ff6c58f02d1cab" => :el_capitan
  end

  depends_on "ucl"

  def install
    (buildpath/"src/lzma-sdk").install resource("lzma-sdk") if build.stable?
    system "make", "all"
    bin.install "src/upx.out" => "upx"
    man1.install "doc/upx.1"
  end

  test do
    cp "#{bin}/upx", "."
    chmod 0755, "./upx"

    system "#{bin}/upx", "-1", "./upx"
    system "./upx", "-V" # make sure the binary we compressed works
    system "#{bin}/upx", "-d", "./upx"
  end
end
