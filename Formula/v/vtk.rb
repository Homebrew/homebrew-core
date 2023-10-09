class Vtk < Formula
  desc "Toolkit for 3D computer graphics, image processing, and visualization"
  homepage "https://www.vtk.org/"
  url "https://www.vtk.org/files/release/9.2/VTK-9.2.6.tar.gz"
  sha256 "06fc8d49c4e56f498c40fcb38a563ed8d4ec31358d0101e8988f0bb4d539dd12"
  license "BSD-3-Clause"
  revision 4
  head "https://gitlab.kitware.com/vtk/vtk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3fec8d6b75f64224dd16fa0ad9995bbd5a32d00ff1ec4e868c6ae51e334739df"
    sha256 cellar: :any,                 arm64_ventura:  "11a861abdb6f6fca6e86b8f71493f7a1988872685c3bf23f33b56f2dace87d28"
    sha256 cellar: :any,                 arm64_monterey: "33bc30a92f2c105848e13f012a7706100af5c452a19cbd0345d99009efa76897"
    sha256 cellar: :any,                 arm64_big_sur:  "30c40c9e5a7f7d67555885e01fcf5d3e74d2c3df43b548b7ed7c4d813c83cfd1"
    sha256 cellar: :any,                 sonoma:         "89d918ff3ffc8ddc42eb7bac5486181b82fe1ddceaf328c8417898a50e66809f"
    sha256 cellar: :any,                 ventura:        "4b1f731c2f8e8464cc06dce10172f2f281eedb983d545638aca4032ee9ee6155"
    sha256 cellar: :any,                 monterey:       "a84d6af8181218bbd298483d029c1d47061b2c0271fe07ce29c7c461b7dce534"
    sha256 cellar: :any,                 big_sur:        "4a2c47ed0ae9f79c1db84ffb19a4f62e63ad1863925aeafcf3f97d4da701b3c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6114a390b3eafad28adfef63983f27fbbbe4ac680f1e7687cd70a119f6ebf04"
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
  depends_on "pyqt"
  depends_on "python@3.11"
  depends_on "qt"
  depends_on "sqlite"
  depends_on "theora"
  depends_on "utf8cpp"
  depends_on "xz"

  uses_from_macos "expat"
  uses_from_macos "libxml2"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_macos do
    on_arm do
      if DevelopmentTools.clang_build_version == 1316
        depends_on "llvm" => :build

        # clang: error: unable to execute command: Segmentation fault: 11
        # clang: error: clang frontend command failed due to signal (use -v to see invocation)
        # Apple clang version 13.1.6 (clang-1316.0.21.2)
        fails_with :clang
      end
    end
  end

  on_linux do
    depends_on "libaec"
    depends_on "mesa-glu"
  end

  fails_with gcc: "5"

  def install
    ENV.llvm_clang if DevelopmentTools.clang_build_version == 1316 && Hardware::CPU.arm?

    python = "python3.11"
    qml_plugin_dir = lib/"qml/VTK.#{version.major_minor}"
    vtkmodules_dir = prefix/Language::Python.site_packages(python)/"vtkmodules"
    rpaths = [rpath, rpath(source: qml_plugin_dir), rpath(source: vtkmodules_dir)]

    args = %W[
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DCMAKE_INSTALL_RPATH:STRING=#{rpaths.join(";")}
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
      -DPython3_EXECUTABLE:FILEPATH=#{which(python)}
      -DVTK_GROUP_ENABLE_Qt:STRING=YES
      -DVTK_QT_VERSION:STRING=6
    ]

    # https://github.com/Homebrew/linuxbrew-core/pull/21654#issuecomment-738549701
    args << "-DOpenGL_GL_PREFERENCE=LEGACY"

    args << "-DVTK_USE_COCOA:BOOL=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
