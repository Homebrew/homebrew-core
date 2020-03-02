class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  url "https://github.com/upx/upx/releases/download/v3.96/upx-3.96-src.tar.xz"
  sha256 "47774df5c958f2868ef550fb258b97c73272cb1f44fe776b798e393465993714"
  head "https://github.com/upx/upx.git", :branch => "devel"

  bottle do
    cellar :any_skip_relocation
    sha256 "1089a067bec1387bfa8080565f95601493291933b83a510057ba6f1e7fd06d91" => :catalina
    sha256 "20ab82b69b19ac0886bd202459b652d85f7bc5c288009dd7caf09017be940d37" => :mojave
    sha256 "4773fc3b7ccb35aad163549a7c5b37813dea9e5c2f1cdfd67a00e7da36691b69" => :high_sierra
  end

  depends_on "ucl" => :build

  uses_from_macos "zlib"

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
