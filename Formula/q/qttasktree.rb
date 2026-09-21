class Qttasktree < Formula
  desc "General purpose library for asynchronous task execution"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.2/submodules/qttasktree-everywhere-src-6.11.2.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.2/submodules/qttasktree-everywhere-src-6.11.2.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.2/submodules/qttasktree-everywhere-src-6.11.2.tar.xz"
  sha256 "c0762992f01616a6cd15efea2658ace1984fb290723aab5406d813cd21c23ed8"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qttasktree.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6043274e82c1f3fa979a980250e0d064dd592e70f685fcc7d3cac67575500cd3"
    sha256 cellar: :any, arm64_tahoe:       "0ef6b7fa3ac87a92cee1e9b0646b00a7d05ad67a383c2fa461bccfc9acfb31fe"
    sha256 cellar: :any, arm64_sequoia:     "660318894683481fa9200fbf20890bc7771feecd5eb3fcc3189d862a8a41fd68"
    sha256 cellar: :any, arm64_sonoma:      "e6bbbfce2034a8b231b486ed2cef08e46bfe9111d1275c9e05aa13d2d57958ba"
    sha256 cellar: :any, arm64_linux:       "2c617c682c6c5d0ca3b5d71174be10e815a2d19ac72ecada057cf59648fc5344"
    sha256 cellar: :any, x86_64_linux:      "a3124e1a03dfb6634b86cae4fe8c46994d23bbfcbf88b9796043231dc194d56d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "qtbase"

  def install
    args = ["-DCMAKE_STAGING_PREFIX=#{prefix}"]
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "tests/auto/threadfunction/tst_qthreadfunction.cpp"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework") if OS.mac?
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(tst_qthreadfunction LANGUAGES CXX)
      set(QT_NO_APPLE_SDK_AND_XCODE_CHECK ON)
      find_package(Qt6BuildInternals REQUIRED COMPONENTS STANDALONE_TEST)

      qt_internal_add_test(tst_qthreadfunction
        SOURCES
          #{pkgshare}/tst_qthreadfunction.cpp
        LIBRARIES
          Qt::TaskTree
      )
    CMAKE

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "cmake", "-S", ".", "-B", "."
    system "cmake", "--build", "."
    system "./tst_qthreadfunction"
  end
end
