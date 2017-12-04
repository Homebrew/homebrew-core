class Simg2img < Formula
  desc "Tool to convert Android sparse images to raw images and back"
  homepage "https://github.com/anestisb/android-simg2img"
  url "https://github.com/anestisb/android-simg2img/archive/1.1.1.tar.gz"
  sha256 "d096ca7e02b3ad5b87cbb6467d3766720355f32aa5ae9b9264d7ca7c486b0738"
  head "https://github.com/anestisb/android-simg2img.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d86b8e4e7b13def022a642ef9a4198a1250cfb8fc0020b2fb5788e331fd92b7" => :high_sierra
    sha256 "2a4e498b96fbb7b30b3b9bdeb3a3d13dbaed1278b768fd8a698f7b8edf9da452" => :sierra
    sha256 "a482e1be3dc43507d87915919589604c1da1b99c9aa7ad204cb50291d2587d2c" => :el_capitan
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
