class Vvenc < Formula
  desc "Fraunhofer Versatile Video Encoder"
  homepage "https://github.com/fraunhoferhhi/vvenc"
  url "https://github.com/fraunhoferhhi/vvenc/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "4ddb365dfc21bbbb7ed54655c7630ae3e8e977af31f22b28195e720215b1072d"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvenc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7da685c30ffce37ad820283633f326a9f4796b41c0e4cdae3a795c3a9893cd4f"
    sha256 cellar: :any,                 arm64_monterey: "a0814b9491e1f492ee907a9c5540f550f364f7bb639a72b1230d6ddb0b58440a"
    sha256 cellar: :any,                 arm64_big_sur:  "89bcfdf23109dd2be872f74339acbdced01635230af469725cd70d553a73cbf2"
    sha256 cellar: :any,                 ventura:        "ffc6ef53b94a8f2298159b53c1610766d06cc3aabd09829874f2bab61914e5af"
    sha256 cellar: :any,                 monterey:       "47c42bd96a026d25d88d4bc1a3f4e1b33147f53d60f6420c07ef14ae2b75c528"
    sha256 cellar: :any,                 big_sur:        "1150b649bdd233056809f89830e4f6f72c4bbe2d8af6cd6df955623f51486220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79eba07adde3b8af1ee50868d8ed9b3600f1f6828125f7a5cdecdcc0d7be1077"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DVVENC_INSTALL_FULLFEATURE_APP=1",
           "-DBUILD_SHARED_LIBS=1",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test_video" do
      url "https://raw.githubusercontent.com/fraunhoferhhi/vvenc/master/test/data/RTn23_80x44p15_f15.yuv"
      sha256 "ecd2ef466dd2975f4facc889e0ca128a6bea6645df61493a96d8e7763b6f3ae9"
    end

    resource("homebrew-test_video").stage testpath
    system bin/"vvencapp",
           "-i", testpath/"RTn23_80x44p15_f15.yuv",
           "-s", "360x640",
           "--fps", "60/1",
           "--format", "yuv420_10",
           "--hdr", "hdr10_2020",
           "-o", testpath/"RTn23_80x44p15_f15.vvc"
    assert_predicate testpath/"RTn23_80x44p15_f15.vvc", :exist?
  end
end
