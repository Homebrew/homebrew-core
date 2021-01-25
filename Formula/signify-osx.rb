class SignifyOsx < Formula
  desc "Cryptographically sign and verify files"
  homepage "https://man.openbsd.org/signify.1"
  url "https://github.com/jpouellet/signify-osx/archive/1.4.tar.gz"
  sha256 "5aa954fe6c54f2fc939771779e5bb64298e46d0a4ae3d08637df44c7ed8d2897"
  license "ISC"
  head "https://github.com/jpouellet/signify-osx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a60c4b4955d38a1effe307e2326373c069621c1135e28820783aedd5aba9788" => :big_sur
    sha256 "04f7c99002246fb5765666759b9a5a1f7e461a6d2d0c77e360af77951ee5de97" => :arm64_big_sur
    sha256 "74a8c2fa3d258ad59a5ab7302411a194903ea5295fbf5ecd95a43c2ac28677f4" => :catalina
    sha256 "842a6fb535ce56db38ca545fd229f184850e34211c7817879f707f71fe6b31d0" => :mojave
    sha256 "cdb1896e5e480edfb6ad7f179d9a2b217cda774039fcf5922bc3eba9b6d3d1bb" => :high_sierra
    sha256 "fdac23b07368d6c8ebad06c2b8451f0c8228f71f5c65b48d672cfd581b222509" => :sierra
  end

  def install
    system "make"
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/signify", "-G", "-n", "-p", "test.pub", "-s", "test.sec"
  end
end
