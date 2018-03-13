class Simg2img < Formula
  desc "Tool to convert Android sparse images to raw images and back"
  homepage "https://github.com/anestisb/android-simg2img"
  url "https://github.com/anestisb/android-simg2img/archive/1.1.3.tar.gz"
  sha256 "82eb629ac0beb67cc97396e031555f0461dcb66e1b93aad53e2f604a18037c51"
  head "https://github.com/anestisb/android-simg2img.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c99ac5e27e01f4a821fe0e92cfa99a92fba103ecef29e2ac0410b487f13b643" => :high_sierra
    sha256 "2e7c9986e8839167ea9903e5086b479cc7468371afeb57469be906c15eea1c8e" => :sierra
    sha256 "77788e91df83e179edb74fa50fc2e68d2849383e4c51b2ba3f0d411e0434e558" => :el_capitan
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
