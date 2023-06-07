class Simg2img < Formula
  desc "Tool to convert Android sparse images to raw images and back"
  homepage "https://github.com/anestisb/android-simg2img"
  url "https://github.com/anestisb/android-simg2img/archive/1.1.4.tar.gz"
  sha256 "cbd32490c1e29d9025601b81089b5aec1707cb62020dfcecd8747af4fde6fecd"
  license "Apache-2.0"
  head "https://github.com/anestisb/android-simg2img.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0dcd750c7e2a018a1947e3b944498f9032dbca077a8b5c90104d33f4db7c248"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4c50b28f615335a6d9dcb2730676b4d3d0b5f1cc02d0279959d313ac0eda6fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd4891712dae2fd35115f8ee32ba703bc3094ff365e52c8fe6a2b0d4694ee1ae"
    sha256 cellar: :any_skip_relocation, ventura:        "fc26e37af726109d97bf20222c18e97efba0d6259381a38380a21f90451fb34d"
    sha256 cellar: :any_skip_relocation, monterey:       "3236b3d33786220a8a09ab5f43b237bd69b45bc397f1011f4075939399d44489"
    sha256 cellar: :any_skip_relocation, big_sur:        "04bb96fc69c1e71931d0fe4b13f122f6036573135c9a228e14fbe54d60ef4515"
    sha256 cellar: :any_skip_relocation, catalina:       "a79238cc3b241a3c9f2635b2ce230107f4372db3df7678dcc0857f8c7ef40581"
    sha256 cellar: :any_skip_relocation, mojave:         "eb4046906b4bc9b2508ed5a7bbd0c9cfd2bab387c9891dbbf396c64374fdef6d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "677aa2ecb11b6c0df59eb44cd75b7bc66d7f99607a4a5e0b5f9137d42428efc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12b3dc2a827326c0a15c73a1ea4dd3a986f68dfdaae65adcf035239c449f066e"
  end

  uses_from_macos "zlib"

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
