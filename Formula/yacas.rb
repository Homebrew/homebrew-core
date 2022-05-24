class Yacas < Formula
  desc "General purpose computer algebra system"
  homepage "https://www.yacas.org/"
  url "https://github.com/grzegorzmazur/yacas/archive/v1.9.1.tar.gz"
  sha256 "36333e9627a0ed27def7a3d14628ecaab25df350036e274b37f7af1d1ff7ef5b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f0be1f32ea2b38ee4066785a1b32d0872a526f9808a9bf5c1b001d044a187b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a063eb4d6d3cef50d8168b87d663da647231f526e2fd9cf3d912b377523161ef"
    sha256 cellar: :any_skip_relocation, monterey:       "5d8e13fe887d88634e484d584ab263ee01c42f9a1852c03f9a5ab24bf23cf553"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfdc56a32f326522a385c3617b185381d056c860cab7aa7f97dde25ea32b29e8"
    sha256 cellar: :any_skip_relocation, catalina:       "be746c1eb1e965cb3d87195fd0094eee7987dbd74b5f3945e1cfe3e6df3a73cb"
    sha256 cellar: :any_skip_relocation, mojave:         "80089e9a9b1e3d64648af1cc34b1142d79332510c6797ea3a2a922d4bf4ccbc2"
    sha256 cellar: :any_skip_relocation, high_sierra:    "10557868ce4e8aa9d146a15b79e0c13e30d3d73c5fee3edaff8e0475678d31bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5ebea55387b89efbff789561075f32ce00b0ffa39df63caf4402365c3b281b5"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with :gcc do
    version "6"
    cause "needs std::string_view"
  end

  def install
    cmake_args = std_cmake_args + [
      "-DENABLE_CYACAS_GUI=OFF",
      "-DENABLE_CYACAS_KERNEL=OFF",
      "-DCMAKE_C_COMPILER=#{ENV.cc}",
      "-DCMAKE_CXX_COMPILER=#{ENV.cxx}",
    ]
    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "scripts"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yacas -v")
  end
end
