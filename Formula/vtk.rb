class Vtk < Formula
  desc "Toolkit for 3D computer graphics, image processing, and visualization"
  homepage "https://www.vtk.org/"
  url "https://www.vtk.org/files/release/9.1/VTK-9.1.0.tar.gz"
  sha256 "8fed42f4f8f1eb8083107b68eaa9ad71da07110161a3116ad807f43e5ca5ce96"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/Kitware/VTK.git", branch: "master"

  bottle do
    rebuild 1
    sha256                               arm64_monterey: "db69b8415e3e2c71e72324a2f345d2bc203b1be420ffef34103581616e875c1b"
    sha256                               arm64_big_sur:  "6cf53d599728a6e8d0b718e42ded3e7e53a669b2f8ac50b0d74aedf12fbebf63"
    sha256                               big_sur:        "d00fb169c11c9609dc895c1678f6641b60b7aad9fac5433c78d5da860ff2d5a2"
    sha256                               catalina:       "1e656d21849e1e191e61c8ffe1b917765e8ba7e0b122538b2c1bbcf2a06d3b11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9947d6db68fe92e18f2c728e1c0cb3d2243e8c1c7699c246850482b1dcdafd10"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "eigen"
  depends_on "fontconfig"
  depends_on "gl2ps"
  depends_on "glew"
  depends_on "hdf5"
  depends_on "jpeg"
  depends_on "jsoncpp"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "lz4"
  depends_on "netcdf"
  depends_on "pugixml"
  depends_on "pyqt@5"
  depends_on "python@3.9"
  depends_on "qt@5"
  depends_on "sqlite"
  depends_on "theora"
  depends_on "utf8cpp"
  depends_on "xz"

  uses_from_macos "expat"
  uses_from_macos "libxml2"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
    depends_on "szip"
    depends_on "mesa-glu"
  end

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_TESTING:BOOL=OFF
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
      -DPython3_EXECUTABLE:FILEPATH=#{Formula["python@3.9"].opt_bin}/python3
      -DVTK_GROUP_ENABLE_Qt:STRING=YES
      -DVTK_QT_VERSION:STRING=5
    ]

    # https://github.com/Homebrew/linuxbrew-core/pull/21654#issuecomment-738549701
    args << "-DOpenGL_GL_PREFERENCE=LEGACY"

    args << "-DVTK_USE_COCOA:BOOL=ON" if OS.mac?

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
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

    vtk_dir = Dir[opt_lib/"cmake/vtk-*"].first
    system "cmake", "-DCMAKE_BUILD_TYPE=Debug", "-DCMAKE_VERBOSE_MAKEFILE=ON",
      "-DVTK_DIR=#{vtk_dir}", "."
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
