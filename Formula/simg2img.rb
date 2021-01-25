class Simg2img < Formula
  desc "Tool to convert Android sparse images to raw images and back"
  homepage "https://github.com/anestisb/android-simg2img"
  url "https://github.com/anestisb/android-simg2img/archive/1.1.4.tar.gz"
  sha256 "cbd32490c1e29d9025601b81089b5aec1707cb62020dfcecd8747af4fde6fecd"
  license "Apache-2.0"
  head "https://github.com/anestisb/android-simg2img.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "04bb96fc69c1e71931d0fe4b13f122f6036573135c9a228e14fbe54d60ef4515" => :big_sur
    sha256 "cd4891712dae2fd35115f8ee32ba703bc3094ff365e52c8fe6a2b0d4694ee1ae" => :arm64_big_sur
    sha256 "a79238cc3b241a3c9f2635b2ce230107f4372db3df7678dcc0857f8c7ef40581" => :catalina
    sha256 "eb4046906b4bc9b2508ed5a7bbd0c9cfd2bab387c9891dbbf396c64374fdef6d" => :mojave
    sha256 "677aa2ecb11b6c0df59eb44cd75b7bc66d7f99607a4a5e0b5f9137d42428efc5" => :high_sierra
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "dd", "if=/dev/zero", "of=512k-zeros.img", "bs=512", "count=1024"
    assert_equal 524288, (testpath/"512k-zeros.img").size?,
                 "Could not create 512k-zeros.img with 512KiB of zeros"
    system bin/"img2simg", "512k-zeros.img", "512k-zeros.simg"
    assert_equal 44, (testpath/"512k-zeros.simg").size?,
                 "Converting 512KiB of zeros did not result in a 44 byte simg"
    system bin/"simg2img", "512k-zeros.simg", "new-512k-zeros.img"
    assert_equal 524288, (testpath/"new-512k-zeros.img").size?,
                 "Converting a 44 byte simg did not result in 512KiB"
    system "diff", "512k-zeros.img", "new-512k-zeros.img"
  end
end
