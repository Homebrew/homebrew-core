class Qttasktree < Formula
  desc "General purpose library for asynchronous task execution"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.11/6.11.0/submodules/qttasktree-everywhere-src-6.11.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.11/6.11.0/submodules/qttasktree-everywhere-src-6.11.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.11/6.11.0/submodules/qttasktree-everywhere-src-6.11.0.tar.xz"
  sha256 "597aa25e7c4d6f4f82c9d57e5d855d509b8ffe9ddae8a6442fb1f0bff1a8b34f"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qttasktree.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "89f2c01934762d967f88cf3a6436cc08f2a9c143c2230dd70102cd5e542775bd"
    sha256 cellar: :any,                 arm64_sequoia: "1b139a2ccd710f7a9fe3f4667c64ebb75b90e52e52c5d4a089dca321e8241f12"
    sha256 cellar: :any,                 arm64_sonoma:  "e1176a37ae92a056ad08bf87f90d4d32407322dda69dd7b105e9871d38e3756c"
    sha256 cellar: :any,                 sonoma:        "03e3c90e84e28d5e181d9d59f238b022be667fbc7b17c99dc2727222399403f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86bc3952e0b86ecd3f5c3d9ed2a0dfdfa7e1bf51c7b0d45399a592772f159e3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbe22e385ace6fcc22fef5f1866ce3468644f2d724ff3b947b747525bdc954fb"
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
