class Simg2img < Formula
  desc "Tool to convert Android sparse images to raw images and back"
  homepage "https://github.com/anestisb/android-simg2img"
  url "https://github.com/anestisb/android-simg2img/archive/1.1.3.tar.gz"
  sha256 "82eb629ac0beb67cc97396e031555f0461dcb66e1b93aad53e2f604a18037c51"
  head "https://github.com/anestisb/android-simg2img.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1660ad2869db6ccc31360ee2070e86ff6ac3e673eb0f279905c59f82607b707a" => :catalina
    sha256 "6eafc98ab24c0f4855a1d1e80a14f0af121d10d2d67d6d7adb4597793122aa71" => :mojave
    sha256 "fdb01a50976fa5baef6f1d2b0fa96718256df5862cdc6e5a2d297f059031ae6f" => :high_sierra
    sha256 "782e2bfbd0c4f74573ad00028910c80d0d1ccc3a1d8aa6275a75c16ff62078fc" => :sierra
    sha256 "6895f9d52514757e07f47c9e18400330177175a1ef12e96ccf10b91577644557" => :el_capitan
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
