class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  url "https://github.com/upx/upx/releases/download/v5.3.1/upx-5.3.1-src.tar.xz"
  sha256 "ece4a0cbbe9b6584de2e39d0d887b3ecdfd1648d5ad8e20266485a76de09c28a"
  license "GPL-2.0-or-later"
  head "https://github.com/upx/upx.git", branch: "devel"

  bottle do
    manifest_sha256 "23647b9db7bc39163b71d7cb5bfa75f113c53846e020788592613c563f0a3f51"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05ba4b8d1f7cd2a086a2a040286030869908f4abc91ea2d6d33069dff185ce06"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fe0b409ae9aca68b7444bb564f9fa4ad6370fcd4ba85dabc8e304b474bcf6b57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "050444ba5db9f251f4caa2f37e4113a926d08cf958e939d6c7c356dcc9708189"
    sha256 cellar: :any,                 arm64_linux:       "e9a4a532dbd7305bbb9a1c6112bae91b10218ddef6c8c0f47d3c98b26b363bbd"
    sha256 cellar: :any,                 x86_64_linux:      "beae33c02c9a859fe4023d974785db478bdbce6954eb5ba0300cb4aad16387e0"
  end

  depends_on "cmake" => :build
  depends_on "ucl" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
