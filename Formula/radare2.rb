class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.0.0.tar.gz"
  sha256 "517dd80ebd0569f31498887338eacb92e8cf054bc4625eef8ffe9ea174c1adae"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git"

  bottle do
    rebuild 1
    sha256 "cb89eeb473aaf506f0a1a0ef5de94d27ce9051dc25a307807e58b81f6ff77def" => :big_sur
    sha256 "806bf4d9bdd9714586cee4a32efb3cf75c735b7329a05e34fa79aa6cce1ee17f" => :arm64_big_sur
    sha256 "2e7491f612ffa9161ed34670cf345f52998b39a99cbe6c7fb3f660e2ac02e592" => :catalina
    sha256 "d40bc7db7d6a8e16bc41aa3db7e622bf324e99af7283501c595140aaeacbe286" => :mojave
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -version")
  end
end
