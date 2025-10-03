class Simg2img < Formula
  desc "Tool to convert Android sparse images to raw images and back"
  homepage "https://github.com/anestisb/android-simg2img"
  url "https://github.com/anestisb/android-simg2img/archive/refs/tags/1.1.5.tar.gz"
  sha256 "d9e9ec2c372dbbb69b9f90b4da24c89b092689e45cd5f74f0e13003bc367f3fc"
  license "Apache-2.0"
  head "https://github.com/anestisb/android-simg2img.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58a7ef68da47e40e6d78c4d848f6c0b27faa50b211114ff21e368fe196855269"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4379d5396841f588cdc104f78d544b13c8ffced771e3951a1f125832c254655e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c521ed91a882110a4bf62d1937e3ed7bf92953b9bf29cafe90a96f414fd8635"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7991544d5ea48f9b2ac646a907165e7196d33198213360276bed43f1fd9cd21c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cb6ebc371ac048e15cf499fc82b8620727669732a0cf9ae522b9a46888e2ac7"
    sha256 cellar: :any_skip_relocation, ventura:       "ef6aec762912ae04441813a968c07bc6463da4df22e479a6745242e811268fa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f76f92bfcc1a1c8a0aed24f14b1ec062deead3839fa236883435aebb8d54cb83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7ee989bd69ca55912a71b8317711a5ed08d5341c7ba5d24156abcb53a9a6135"
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
