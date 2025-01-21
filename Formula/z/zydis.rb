class Zydis < Formula
  desc "Fast and lightweight x86/x86_64 disassembler library"
  homepage "https://zydis.re"
  # pull from git tag to get submodules
  url "https://github.com/zyantific/zydis.git",
      tag:      "v4.1.0",
      revision: "569320ad3c4856da13b9dbf1f0d9e20bda63870e"
  license "MIT"
  head "https://github.com/zyantific/zydis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "263d39ea63e80fa442ab2b1dd6891fcb87cc0941cb72825999a8150353392e3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f7f72365b14908bbdfdf6b97cc058250e587f7edca69a75d3d63ac113f1933e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db12deb4305fb8967c2900ba080d5a02c7a57c8aaac3dee595b301115dc81276"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b9f1a1d12f1cf6db4a24835b7b2b4ba069d4003471b71615b5e56c5740cd325"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0f44abbde404047f49cc7c6d558c21040100f104952af5dbd6587badcaf9072"
    sha256 cellar: :any_skip_relocation, ventura:        "27de11023e425dd95749c1188ba14213706ef99907086ce405582ed3189871e8"
    sha256 cellar: :any_skip_relocation, monterey:       "55fe031082cf04e183669954faa236dcc5561aa1cca00852362652432f40e68d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f300c27bd81d350987eb65ed20958866564e7d410018bff4b99978cd375b259"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DZYDIS_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/ZydisInfo -64 66 3E 65 2E F0 F2 F3 48 01 A4 98 2C 01 00 00")
    assert_match "xrelease lock add qword ptr gs:[rax+rbx*4+0x12C], rsp", output
  end
end
