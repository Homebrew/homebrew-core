class Qttasktree < Formula
  desc "General purpose library for asynchronous task execution"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qttasktree-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qttasktree-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qttasktree-everywhere-src-6.12.0.tar.xz"
  sha256 "d28cac0d1fc2d87fbc8fd70d4f956a79b2d37a039df2766e9ff0f69635596b5e"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  revision 1
  head "https://code.qt.io/qt/qttasktree.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "472e73f7476bd4e4abc01f8c7d24adc70cb8f6cbe29ea371c358f5e07e3fa96d"
    sha256 cellar: :any, arm64_tahoe:       "a765704da0fe5c72bd44662059e58e0888117c3e18d468ccc292a53eaa3963ad"
    sha256 cellar: :any, arm64_sequoia:     "d73d736d7e09c41f05d2b3f7a45a7bb05c53407a99f455123c4178a95ae843a0"
    sha256 cellar: :any, arm64_linux:       "86e87d3111f27e228d08c0636a16291380148ad51ba9036b63fef422a35f4d8d"
    sha256 cellar: :any, x86_64_linux:      "fede8b6f805ca65b0a256def7899c44185ffbc9b7a2e2d820c48a732e93c7a90"
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
