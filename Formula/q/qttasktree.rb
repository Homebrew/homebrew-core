class Qttasktree < Formula
  desc "General purpose library for asynchronous task execution"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.1/submodules/qttasktree-everywhere-src-6.11.1.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.1/submodules/qttasktree-everywhere-src-6.11.1.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.1/submodules/qttasktree-everywhere-src-6.11.1.tar.xz"
  sha256 "a22ab97f8f4d37a4d6616d577b70edcac29fdf78b77c819eb0ef111187e74dd6"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qttasktree.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "44d8803de1d5759dafc94f0acee6ac70f1269b6f7f159cef3bf248aec8e49ec1"
    sha256 cellar: :any,                 arm64_sequoia: "24ddab01d6f9b3db3c2628be8adabbd2e30cd9c2b8d93f9d786937ced31b45de"
    sha256 cellar: :any,                 arm64_sonoma:  "6bd4eb72d0374ece2a0b729b58fbbfaf0127791fba1c8cc3d10a997f9a65521b"
    sha256 cellar: :any,                 sonoma:        "6bae2db4b884f3e5d115a4ab1900995fbc250eeda4ab186db087106cfbad63e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21bd28ec9bd4006eaeaa3fbeba71d22ef46fdbaa0ca373a96bda415431f65fa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "922695b2c93c4eb28c256e49aadc2d3c23a6694706155a8e61912279fbbac3c6"
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
