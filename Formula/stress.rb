class Stress < Formula
  desc "Tool to impose load on and stress test a computer system"
  homepage "https://web.archive.org/web/20190702093856/https://people.seas.harvard.edu/~apw/stress/"
  url "https://deb.debian.org/debian/pool/main/s/stress/stress_1.0.4.orig.tar.gz"
  sha256 "057e4fc2a7706411e1014bf172e4f94b63a12f18412378fca8684ca92408825b"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/s/stress/"
    regex(/href=.*?stress[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8189828c418971cd3fc6aff2a4b5fbb7ceb8932e989614d5a9aeff29bc54459c"
    sha256 cellar: :any_skip_relocation, big_sur:       "0e595d39f5d02ac50b4ef52311ef96bdd6d669fb1cff4fd9a9e99c105156a1c8"
    sha256 cellar: :any_skip_relocation, catalina:      "c5da803a76518e3441f5e7da17a6c1972f0db3d8e407edb95a364aee3d9f7c7e"
    sha256 cellar: :any_skip_relocation, mojave:        "6b20923f6f1f46c8e71b4e6a9546dff1f4b290d94805a35e8f3ddffad9cbbfbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72cd939f3cdd4d1982e891bf3b91aadd684cdce764ad9f52711dbe0ada2a0099"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"stress", "--cpu", "2", "--io", "1", "--vm", "1", "--vm-bytes", "128M", "--timeout", "1s", "--verbose"
  end
end
