class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20200610.tgz"
  sha256 "8b52bc63b0e19feb15e3a044f0814a73e4f43306dd93362f9ad8bd94d2a40105"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ed2226713142cbe3358b35cc20b1b5f566e8a337593db770d395c47ce807d08" => :catalina
    sha256 "150b0841791012479c9afda2f44511595d38685e7c4720a4a29c9298409a72be" => :mojave
    sha256 "5bcfa979eae920e1e2e87da085ebd6060ee449fee35f464db1bfb86d4528c486" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output(bin/"vttest -V")
  end
end
