class Vtk < Formula
  desc "Toolkit for 3D computer graphics, image processing, and visualization"
  homepage "https://www.vtk.org/"
  url "https://www.vtk.org/files/release/9.7/VTK-9.7.1.tar.gz"
  sha256 "cae04fd355004cb916a409db79d53a208f1221e975aeacc7540ee67b148ee91a"
  license "BSD-3-Clause"
  compatibility_version 4
  head "https://gitlab.kitware.com/vtk/vtk.git", branch: "master"

  livecheck do
    url "https://vtk.org/download/"
    regex(/href=.*?vtk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ec90108f09c274ee0c4d757f355cd9403eaca034482050170c74ca1f40ad7437"
    sha256 cellar: :any, arm64_tahoe:       "f864a5d7679adedc617c61d60db26af3ed1fd74d93c049d4d285580f51d8fe48"
    sha256 cellar: :any, arm64_sequoia:     "f6cd1d7814f06095c8475d1232c211c9cde6d274eb2019645928856cb74295d1"
    sha256 cellar: :any, arm64_linux:       "d40b1365da98ea631f5945cd4495bf28d0955987ef81226d6570f45534ae5e1f"
    sha256 cellar: :any, x86_64_linux:      "2d22dd5483250e666419544422b3c31ef60391303cc2db0097b5f78a1ffa7e98"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pyqt" => :test
  depends_on "boost"
  depends_on "cgns"
  depends_on "double-conversion"
  depends_on "eigen"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "hdf5"
  depends_on "jpeg-turbo"
  depends_on "jsoncpp"
  depends_on "libharu"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "lz4"
  depends_on "netcdf"
  depends_on "nlohmann-json"
  depends_on "proj"
  depends_on "pugixml"
  depends_on "python@3.15"
  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "sqlite"
  depends_on "theora"
  depends_on "utf8cpp"
  depends_on "xz"

  uses_from_macos "expat", since: :sequoia
  uses_from_macos "libxml2"

  on_linux do
    depends_on "gl2ps"
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  # Backport fix for HDF5 2.0.0 from CMake repo
  patch :p2 do
    url "https://github.com/Kitware/CMake/commit/27e558dfa5a5441954d8930f2b6d9ae700c95050.patch?full_index=1"
    sha256 "ba4ecd3f9abfaae2c60c9be6978c250622bdb9979b42ddec52116d51d034f911"
    directory "CMake/patches/99"
    type :cherry_pick
    resolves "https://gitlab.kitware.com/vtk/vtk/-/work_items/20014"
  end

  def install
    qml_plugin_dir = lib/"qml/VTK.#{version.major_minor}"
    vtkmodules_dir = prefix/Language::Python.site_packages(python3)/"vtkmodules"
    rpaths = [rpath, rpath(source: qml_plugin_dir), rpath(source: vtkmodules_dir)]

    args = %W[
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DCMAKE_INSTALL_RPATH:STRING=#{rpaths.join(";")}
      -DCMAKE_DISABLE_FIND_PACKAGE_ICU:BOOL=ON
      -DCMAKE_CXX_STANDARD=14
      -DVTK_IGNORE_CMAKE_CXX11_CHECKS=ON
      -DVTK_WRAP_PYTHON:BOOL=ON
      -DVTK_PYTHON_VERSION:STRING=3
      -DVTK_LEGACY_REMOVE:BOOL=ON
      -DVTK_MODULE_ENABLE_VTK_InfovisBoost:STRING=YES
      -DVTK_MODULE_ENABLE_VTK_InfovisBoostGraphAlgorithms:STRING=YES
      -DVTK_MODULE_ENABLE_VTK_RenderingFreeTypeFontConfig:STRING=YES
      -DVTK_MODULE_USE_EXTERNAL_VTK_cgns:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_doubleconversion:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_eigen:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_expat:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_freetype:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_hdf5:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_jpeg:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_jsoncpp:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_libharu:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_libproj:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_libxml2:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_lz4:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_lzma:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_netcdf:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_nlohmannjson:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_ogg:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_png:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_pugixml:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_sqlite:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_theora:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_tiff:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_utf8:BOOL=ON
      -DVTK_MODULE_USE_EXTERNAL_VTK_zlib:BOOL=ON
      -DPython3_EXECUTABLE:FILEPATH=#{python3}
      -DVTK_GROUP_ENABLE_Qt:STRING=YES
      -DVTK_QT_VERSION:STRING=6
    ]
    # External gl2ps causes failure linking to macOS OpenGL.framework
    args << "-DVTK_MODULE_USE_EXTERNAL_VTK_gl2ps:BOOL=ON" unless OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    vtk_dir = lib/"cmake/vtk-#{version.major_minor}"
    vtk_cmake_module = vtk_dir/"VTK-vtk-module-find-packages.cmake"
    assert_match Formula["boost"].version.major_minor_patch.to_s, vtk_cmake_module.read,
                 "VTK needs to be rebuilt against Boost!"

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0 FATAL_ERROR)
      project(Distance2BetweenPoints LANGUAGES CXX)
      find_package(VTK REQUIRED COMPONENTS vtkCommonCore CONFIG)
      add_executable(Distance2BetweenPoints Distance2BetweenPoints.cxx)
      target_link_libraries(Distance2BetweenPoints PRIVATE ${VTK_LIBRARIES})
    CMAKE

    (testpath/"Distance2BetweenPoints.cxx").write <<~CPP
      #include <cassert>
      #include <vtkMath.h>
      int main() {
        double p0[3] = {0.0, 0.0, 0.0};
        double p1[3] = {1.0, 1.0, 1.0};
        assert(vtkMath::Distance2BetweenPoints(p0, p1) == 3.0);
        return 0;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_BUILD_TYPE=Debug", "-DCMAKE_VERBOSE_MAKEFILE=ON",
                    "-DVTK_DIR=#{vtk_dir}"
    system "cmake", "--build", "build"
    system "build/Distance2BetweenPoints"

    (testpath/"Distance2BetweenPoints.py").write <<~PYTHON
      import vtk
      p0 = (0, 0, 0)
      p1 = (1, 1, 1)
      assert vtk.vtkMath.Distance2BetweenPoints(p0, p1) == 3
    PYTHON

    system bin/"vtkpython", "Distance2BetweenPoints.py"
    system bin/"vtkpython", "-c", "from vtkmodules.qt.QVTKRenderWindowInteractor import QVTKRenderWindowInteractor"
  end
end
