class Zopfli < Formula
  desc "New zlib (gzip, deflate) compatible compressor"
  homepage "https://github.com/google/zopfli"
  url "https://github.com/google/zopfli/archive/zopfli-1.0.3.tar.gz"
  sha256 "e955a7739f71af37ef3349c4fa141c648e8775bceb2195be07e86f8e638814bd"
  license "Apache-2.0"
  head "https://github.com/google/zopfli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d60005d0944419b4f6c570c66b906701411d380030f7b6f148347b3b9fbff04" => :big_sur
    sha256 "8713f7f74eeab80dad2dfe679e985c11479f86385e0d4de4673365d47c7683ff" => :arm64_big_sur
    sha256 "aa44f1667254347800d442b6347d6df658e3ee24386d2284cce8e88a27e87d6d" => :catalina
    sha256 "521a5185b6881c878be60af7df7c673f5845255f957b88d01307eb9220407a52" => :mojave
    sha256 "fb474057725b73aa00261b10d000474cb05c020b7d951d085dcf9ed5b0973030" => :high_sierra
  end

  def install
    system "make", "zopfli", "zopflipng"
    bin.install "zopfli", "zopflipng"
  end

  test do
    system "#{bin}/zopfli"
    system "#{bin}/zopflipng", test_fixtures("test.png"), "#{testpath}/out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
