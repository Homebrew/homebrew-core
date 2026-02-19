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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ef2e584274fd5642063c5d7bf9d7703f53dddff875dda63bec93dd02494adbae"
    sha256 cellar: :any,                 arm64_sequoia: "13027b516f281a9ef843fdceae4605cf760d4b5d1cf214a5c876c44faaacb289"
    sha256 cellar: :any,                 arm64_sonoma:  "d5a28a5ec0e6fef247462ce5b68578c7622567e09d5bd67039f9627f505f50af"
    sha256 cellar: :any,                 sonoma:        "9a590e8d60b1bf8861fe929c3ef8b48d86cd09ad284ca3d18301c953535f40e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ba0d90b02aaee75c6524eaf32735d5490df9acabb564505dbc830f99a46822b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50798411da1cae2c7cfec2d965db058f705791f3799cf7040baacd45518150ce"
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
