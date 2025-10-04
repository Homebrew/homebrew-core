class Teem < Formula
  desc "Libraries for scientific raster data"
  homepage "https://teem.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/teem/teem/1.11.0/teem-1.11.0-src.tar.gz"
  sha256 "a01386021dfa802b3e7b4defced2f3c8235860d500c1fa2f347483775d4c8def"
  # License is LGPL-2.1-or-later with a non-SPDX license exception for linking
  license :cannot_represent
  head "https://svn.code.sf.net/p/teem/code/teem/trunk"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "f4d6028758c3ab8fc8c0aac33a7d8ba0326c175d0cc4e2b0ec717b2d20e923da"
    sha256 cellar: :any,                 arm64_sequoia:  "81b45cdf2ea8755adac691f6e58accc314cf9ddfe9152c3f017fd839df3da9c2"
    sha256 cellar: :any,                 arm64_sonoma:   "3e9555bbe75fe5a36a3f62a36434158fa024153accdb69266ffce6d59254fed7"
    sha256 cellar: :any,                 arm64_ventura:  "675bc15ec206fbcdd01c475ae95b82f8fbb5f8143bd781ee87ba09971eb75d84"
    sha256 cellar: :any,                 arm64_monterey: "1c2da9c13e69b5cf2729b29ee33b48208963735e6e0394a17709993e6457a0e3"
    sha256                               arm64_big_sur:  "92abe3197ae4ee54df9af997f519538bd8e2b93f5221185f02aaa61de4b5e5aa"
    sha256 cellar: :any,                 sonoma:         "c65d52399cfdd28153cde34b05075a2be6fb2e1530f5b6f9d3a971fcf4115c27"
    sha256 cellar: :any,                 ventura:        "d4dec6840b897d0a4c59e41beb0802a6fb1c4736974558c4f96485ad3bb34792"
    sha256 cellar: :any,                 monterey:       "f179c33f2bb70a99d4f52e47f21dd8be70e49642607f47af90b1d5001f369d48"
    sha256                               big_sur:        "c7c9999dbb12db2cfd64815a3df772be7222278bb22e857b72d0db0101d498af"
    sha256                               catalina:       "105f54c1cb830584bcf694756ab18eab2a7d9a67e3226699272c4449cc2f816e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b136f971a5b05201d52c353da5db32fb4d0781d79ded3ac590425f03e12ea3b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5940970f22f2f7c70ad15cda8f227df675d47924d4a37ff5461699dde188f7f"
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  uses_from_macos "zlib"

  # Fixes build with CMake 4.0+.
  patch :DATA

  def install
    # Installs CMake archive files directly into lib, which we discourage.
    # Workaround by adding version to libdir & then symlink into expected structure.
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DTeem_USE_LIB_INSTALL_SUBDIR=ON
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    lib.install_symlink Dir.glob(lib/"Teem-#{version}/#{shared_library("*")}")
    (lib/"cmake/teem").install_symlink Dir.glob(lib/"Teem-#{version}/*.cmake")
  end

  test do
    system bin/"nrrdSanity"
  end
end

__END__
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -413,7 +413,7 @@ ELSE(Teem_USE_LIB_INSTALL_SUBDIR)
   SET(EXTRA_INSTALL_PATH "")
 ENDIF(Teem_USE_LIB_INSTALL_SUBDIR)

-INSTALL(TARGETS teem
+INSTALL(TARGETS teem EXPORT teem-export
   RUNTIME DESTINATION bin
   LIBRARY DESTINATION lib${EXTRA_INSTALL_PATH}
   ARCHIVE DESTINATION lib${EXTRA_INSTALL_PATH}
@@ -448,7 +448,7 @@ ENDIF(BUILD_TESTING)
 #-----------------------------------------------------------------------------
 # Help outside projects build Teem projects.
 INCLUDE(CMakeExportBuildSettings)
-EXPORT_LIBRARY_DEPENDENCIES(${Teem_BINARY_DIR}/TeemLibraryDepends.cmake)
+install(EXPORT teem-export DESTINATION lib${EXTRA_INSTALL_PATH} FILE TeemLibraryDepends.cmake)
 CMAKE_EXPORT_BUILD_SETTINGS(${Teem_BINARY_DIR}/TeemBuildSettings.cmake)

 SET(CFLAGS "${CMAKE_C_FLAGS}")
@@ -512,6 +512,5 @@ INSTALL(FILES
   "${Teem_BINARY_DIR}/CMake/TeemConfig.cmake"
   "${Teem_SOURCE_DIR}/CMake/TeemUse.cmake"
   "${Teem_BINARY_DIR}/TeemBuildSettings.cmake"
-  "${Teem_BINARY_DIR}/TeemLibraryDepends.cmake"
   DESTINATION lib${EXTRA_INSTALL_PATH}
   )
