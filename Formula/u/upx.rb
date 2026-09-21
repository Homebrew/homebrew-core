class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  url "https://github.com/upx/upx/releases/download/v5.2.1/upx-5.2.1-src.tar.xz"
  sha256 "a7d457be4ef942e46844ee8f301206b111394cbcbde3599747a6904c54ff116b"
  license "GPL-2.0-or-later"
  head "https://github.com/upx/upx.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3bc4e59bd78ef5a0fbe55590f2657139a4f16db386eb8f9cb016cb02f355a2f4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dde87ba555dc9b24e4c337093235109f7781df57dcd42af79286eb0ff30a795a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7a1af9f665fb5da5e75ee81fbf95fa457547f0e5c2026e9b23ecad032950001f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "a9e1325f4b2c8cadf6b21e5d01527f335c7219748bda8dcf2ec1531ae5b2e386"
    sha256 cellar: :any,                 arm64_linux:       "3111006a975d93984ffc297256581bea3911802022b6f41822ceda31d91907c4"
    sha256 cellar: :any,                 x86_64_linux:      "272032481c3420582258ab2681d61a8f0c6ac99d17c0c02374a1d72a67c161b3"
  end

  depends_on "cmake" => :build
  depends_on "ucl" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"upx", "-1", "-o", "./hello", test_fixtures("elf/c.elf")
    assert_path_exists testpath/"hello"
    system bin/"upx", "-d", "./hello"
  end
end
