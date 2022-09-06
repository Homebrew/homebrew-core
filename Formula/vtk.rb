class Vtk < Formula
  desc "Toolkit for 3D computer graphics, image processing, and visualization"
  homepage "https://www.vtk.org/"
  # TODO: Remove `ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib` at rebuild.
  license "BSD-3-Clause"
  revision 7
  head "https://gitlab.kitware.com/vtk/vtk.git", branch: "master"

  stable do
    url "https://www.vtk.org/files/release/9.1/VTK-9.1.0.tar.gz"
    sha256 "8fed42f4f8f1eb8083107b68eaa9ad71da07110161a3116ad807f43e5ca5ce96"

    # Fix vtkpython support for Python 3.10. Remove in the next release.
    # First patch backports part of older commit so we can directly patch in upstream commit.
    patch :DATA
    patch do
      url "https://gitlab.kitware.com/vtk/vtk/-/commit/3eea0e12acfb608a76d6ae36fb36566a4a6b0e9b.diff"
      sha256 "1c1c4622a58f8c852d196759c8d9036e4d513a5ebe16fe0bfa14583832886572"
    end
  end

  bottle do
    sha256                               arm64_monterey: "33456b64eecdf614f7db9d5b4a11145e660d9d6dc3f5c48b7c9e19958b722b78"
    sha256                               arm64_big_sur:  "f03fb2e0b2c54b0eef6fc5f1f7665c5e9fade0025c3fe62a4e57eb0622c160cd"
    sha256                               monterey:       "d651127e36f34dc5218d9bf36b700bf6786261e3237092569382d31e94fbfbe6"
    sha256                               big_sur:        "aa60276bc28b6a8d94d95f098caaa2ed3652c4ae7a536842f49c049b5dcc151e"
    sha256                               catalina:       "8290e82320543d08c058312d803d3cbd78ba58d7bce9e44e6853b010129b08ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f15c9f69ea940f69a2938f8cfdfa742fa5eac35e7d4788d5785856db7f06245b"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "eigen"
  depends_on "fontconfig"
  depends_on "gl2ps"
  depends_on "glew"
  depends_on "hdf5"
  depends_on "jpeg-turbo"
  depends_on "jsoncpp"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "lz4"
  depends_on "netcdf"
  depends_on "pugixml"
  depends_on "pyqt@5"
  depends_on "python@3.10"
  depends_on "qt@5"
  depends_on "sqlite"
  depends_on "theora"
  depends_on "utf8cpp"
  depends_on "xz"

  uses_from_macos "expat"
  uses_from_macos "libxml2"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version == 1316 && Hardware::CPU.arm?
  end

  on_linux do
    depends_on "libaec"
    depends_on "mesa-glu"
  end

  fails_with gcc: "5"

  # clang: error: unable to execute command: Segmentation fault: 11
  # clang: error: clang frontend command failed due to signal (use -v to see invocation)
  # Apple clang version 13.1.6 (clang-1316.0.21.2)
  fails_with :clang if DevelopmentTools.clang_build_version == 1316 && Hardware::CPU.arm?

  def install
    if DevelopmentTools.clang_build_version == 1316 && Hardware::CPU.arm?
      ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
      ENV.llvm_clang
    end

    args = %W[
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{opt_lib}
      -DCMAKE_INSTALL_RPATH:STRING=#{rpath}
      -DCMAKE_DISABLE_FIND_PACKAGE_ICU:BOOL=ON
      -DVTK_WRAP_PYTHON:BOOL=ON
      -DVTK_PYTHON_VERSION:STRING=3
      -DVTK_LEGACY_REMOVE:BOOL=ON
      -DVTK_MODULE_ENABLE_VTK_InfovisBoost:STRING=YES
      -DVTK_MODULE_ENABLE_VTK_InfovisBoostGraphAlgorithms:STRING=YES
      -DVTK_MODULE_ENABLE_VTK_RenderingFreeTypeFontConfig:STRING=YES
      -DVTK_MODULE_USE_EXTERNAL_VTK_doubleconversion:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_eigen:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_expat:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_gl2ps:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_glew:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_hdf5:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_jpeg:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_jsoncpp:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_libxml2:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_lz4:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_lzma:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_netcdf:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_ogg:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_png:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_pugixml:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_sqlite:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_theora:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_tiff:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_utf8:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_zlib:BOOL=ON
      -DPython3_EXECUTABLE:FILEPATH=#{which("python3.10")}
      -DVTK_GROUP_ENABLE_Qt:STRING=YES
      -DVTK_QT_VERSION:STRING=5
    ]

    # https://github.com/Homebrew/linuxbrew-core/pull/21654#issuecomment-738549701
    args << "-DOpenGL_GL_PREFERENCE=LEGACY"

    args << "-DVTK_USE_COCOA:BOOL=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Force use of Apple Clang on macOS that needs LLVM to build
    ENV.clang if DevelopmentTools.clang_build_version == 1316 && Hardware::CPU.arm?

    vtk_dir = lib/"cmake/vtk-#{version.major_minor}"
    vtk_cmake_module = vtk_dir/"VTK-vtk-module-find-packages.cmake"
    assert_match Formula["boost"].version.to_s, vtk_cmake_module.read, "VTK needs to be rebuilt against Boost!"

    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.3 FATAL_ERROR)
      project(Distance2BetweenPoints LANGUAGES CXX)
      find_package(VTK REQUIRED COMPONENTS vtkCommonCore CONFIG)
      add_executable(Distance2BetweenPoints Distance2BetweenPoints.cxx)
      target_link_libraries(Distance2BetweenPoints PRIVATE ${VTK_LIBRARIES})
    EOS

    (testpath/"Distance2BetweenPoints.cxx").write <<~EOS
      #include <cassert>
      #include <vtkMath.h>
      int main() {
        double p0[3] = {0.0, 0.0, 0.0};
        double p1[3] = {1.0, 1.0, 1.0};
        assert(vtkMath::Distance2BetweenPoints(p0, p1) == 3.0);
        return 0;
      }
    EOS

    system "cmake", ".", "-DCMAKE_BUILD_TYPE=Debug", "-DCMAKE_VERBOSE_MAKEFILE=ON", "-DVTK_DIR=#{vtk_dir}"
    system "make"
    system "./Distance2BetweenPoints"

    (testpath/"Distance2BetweenPoints.py").write <<~EOS
      import vtk
      p0 = (0, 0, 0)
      p1 = (1, 1, 1)
      assert vtk.vtkMath.Distance2BetweenPoints(p0, p1) == 3
    EOS

    system bin/"vtkpython", "Distance2BetweenPoints.py"
  end
end

__END__
diff --git a/Documentation/release/dev/python-3.10-wheels.md b/Documentation/release/dev/python-3.10-wheels.md
new file mode 100644
index 0000000000000000000000000000000000000000..f4e81411c73f30724ad420ccb7f3c6c07a6f8e3d
--- /dev/null
+++ b/Documentation/release/dev/python-3.10-wheels.md
@@ -0,0 +1,7 @@
+## Python 3.10 wheels
+
+VTK now generates Python 3.10 wheels. Note that `vtkpython` and other tools
+using `vtkPythonInterpreter` still do not support the new initialization
+behaviors introduced in Python 3.10. See [this issue][vtk-python-3.10-support].
+
+[vtk-python-3.10.support]: https://gitlab.kitware.com/vtk/vtk/-/issues/18317
