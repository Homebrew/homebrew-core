class Yacas < Formula
  desc "General purpose computer algebra system"
  homepage "https://www.yacas.org/"
  url "https://github.com/grzegorzmazur/yacas/archive/v1.9.1.tar.gz"
  sha256 "36333e9627a0ed27def7a3d14628ecaab25df350036e274b37f7af1d1ff7ef5b"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae76071faf78ed8f1587d59f8c0824e1b2771441b74f0ec407eec3dee48d4e8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd6b1d30d48f91c16cf3ca17747ca75fc7c1b12a3f01a6403ba1cf91cca898a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "143e5dae60ab7011781c9b6f3ce1be4e90f8b1f6914736a8d6ab941a1bacdaf0"
    sha256 cellar: :any_skip_relocation, ventura:        "545dfeabd4103387c097ac475250b0dc63d03eaf5f552a5f846e621dc2b166d1"
    sha256 cellar: :any_skip_relocation, monterey:       "bb3448a3fa65b7a2f59240f7d434354e1a4c353ac37721e3c9490e6ce9067b7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a0cccf6e345290321cf12858a60f9fd3ccbc3e7f05ad30f544d61b2946566b5"
    sha256 cellar: :any_skip_relocation, catalina:       "304721aa2947579ecf84d13afca543a252a6ee6ec5d3efe1490d598988116497"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a754ab2fbf89ee984bdca70f8cdfec48f2323a8d4acba7813d7b7aa621df99d9"
  end

  depends_on "cmake" => :build

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
