class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  revision 1
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

    # The following two patches fix an issue where UPX 3.95 produces broken go binaries - will be fixed in 3.96
    # See https://github.com/upx/upx/issues/222 for details
    patch do
      url "https://github.com/upx/upx/commit/4d1c754af943f4640062884f38742fd97a6bda0d.patch?full_index=1"
      sha256 "64c1cbfd2127172bab973be5cdfba3ad05b0ee506c9076eb6bf0e2d8b4d205b0"
    end

    patch do
      url "https://github.com/upx/upx/commit/bb1f9cdecd02130e468b9bed680a9bb6122f8a0c.patch?full_index=1"
      sha256 "2712240751a0b5c6cb3e4d562fc79b125d612f1f185cd84766fcee12900dea61"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4e49be10264340e0c964f9595bedf797df5b18c4489a32265d049bdc371d07ea" => :catalina
    sha256 "29c7ae82e1fda0f801c388d874d02d9371ca5c7842ae9a8355a16eb2daa8035f" => :mojave
    sha256 "bd7b838097f139055c99a692f9e74f62582d020203d649a190d74c9e9ccab584" => :high_sierra
    sha256 "209bff5e1c4622c2e8f19ef8855e006ad5fb2fde93f937717b39c9aebc4de07e" => :sierra
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
