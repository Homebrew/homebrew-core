class Simg2img < Formula
  desc "Tool to convert Android sparse images to raw images and back"
  homepage "https://github.com/anestisb/android-simg2img"
  url "https://github.com/anestisb/android-simg2img/archive/refs/tags/1.1.5.tar.gz"
  sha256 "d9e9ec2c372dbbb69b9f90b4da24c89b092689e45cd5f74f0e13003bc367f3fc"
  license "Apache-2.0"
  head "https://github.com/anestisb/android-simg2img.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24a4849d1dd7c830c30fe616fb752e3fd0c2fb11313ada32d3355762d4765881"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9577828d12632f3b93ffb4a5ab7d41ec8a103c0c79bf3f63b82b2c5c4824b7bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c21744d5cf470ad2f34d56744744239bac51f08cdf3bfec889815536cf4a517"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbb8d4abc6e1771b2ad35ad31e8de166b9ffbdf4999c7578ab90d4fc381fcff9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47dc8a4e077eddf71ba9eec796d93fe4b2418ce7d848c17f0269a81865d93518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12395fc0ab3bc7182727330297eba9ac9db3d3ae9e52e256943f2dd0af38c561"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
