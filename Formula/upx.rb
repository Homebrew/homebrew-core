class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  url "https://github.com/upx/upx/releases/download/v3.96/upx-3.96-src.tar.xz"
  sha256 "47774df5c958f2868ef550fb258b97c73272cb1f44fe776b798e393465993714"
  head "https://github.com/upx/upx.git", :branch => "devel"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e49be10264340e0c964f9595bedf797df5b18c4489a32265d049bdc371d07ea" => :catalina
    sha256 "29c7ae82e1fda0f801c388d874d02d9371ca5c7842ae9a8355a16eb2daa8035f" => :mojave
    sha256 "bd7b838097f139055c99a692f9e74f62582d020203d649a190d74c9e9ccab584" => :high_sierra
    sha256 "209bff5e1c4622c2e8f19ef8855e006ad5fb2fde93f937717b39c9aebc4de07e" => :sierra
  end

  depends_on "ucl" => :build

  def install
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
