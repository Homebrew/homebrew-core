class Vtk < Formula
  desc "Toolkit for 3D computer graphics, image processing, and visualization"
  homepage "https://www.vtk.org/"
  url "https://www.vtk.org/files/release/9.0/VTK-9.0.1.tar.gz"
  sha256 "1b39a5e191c282861e7af4101eaa8585969a2de05f5646c9199a161213a622c7"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/Kitware/VTK.git"

  bottle do
    sha256 "dcc3fa7f78f1aab1488e0a40bc2e6edc860ef21b20fd9154f2652ebf21311fa0" => :big_sur
    sha256 "8ccd05b41f1fefbde39dcf16b8bcbad70c826b7bd85a2348cc859ca68535cadc" => :catalina
    sha256 "6444f12da98f4234afc2b1a096bd6e7c880a71f1d4f0521fc91e21c90feb7366" => :mojave
    sha256 "e0d7a74bbd039760bd71f95e33c4bb255d1c9769ce17898ca7f58179c811a263" => :high_sierra
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
  depends_on "pyqt"
  depends_on "python@3.9"
  depends_on "qt"
  depends_on "sqlite"
  depends_on "theora"
  depends_on "xz"
  uses_from_macos "expat"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    # Do not record compiler path because it references the shim directory
    inreplace "Common/Core/vtkConfigure.h.in", "@CMAKE_CXX_COMPILER@", "clang++"

    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_TESTING:BOOL=OFF
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      -DCMAKE_INSTALL_RPATH:STRING=#{lib}
      -DVTK_WRAP_PYTHON:BOOL=ON
      -DVTK_PYTHON_VERSION:STRING=3
      -DVTK_USE_COCOA:BOOL=ON
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
      -DVTK_MODULE_USE_EXTERNAL_VTK_zlib:BOOL=ON
      -DPython3_EXECUTABLE:FILEPATH=#{Formula["python@3.9"].opt_bin}/python3
      -DVTK_GROUP_ENABLE_Qt:STRING=YES
    ]

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
