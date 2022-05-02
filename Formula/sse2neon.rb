class Sse2neon < Formula
  desc "A translator from Intel SSE intrinsics to Arm/Aarch64 NEON implementation"
  homepage "https://github.com/DLTcollab/sse2neon"
  url "https://github.com/DLTcollab/sse2neon/archive/v1.5.0.tar.gz"
  sha256 "92ab852aac6c8726a615f77438f2aa340f168f9f6e70c72033d678613e97b65a"
  license "MIT"
  head "https://github.com/DLTcollab/sse2neon.git", branch: "master"

  def install
    include.install "sse2neon.h"

    libexec.install "Makefile"
    libexec.install "tests"
  end

  test do
    cp_r Dir["#{libexec}/*"], testpath
    ln_s opt_include/"sse2neon.h", testpath
    system "make", "check"
  end
end
