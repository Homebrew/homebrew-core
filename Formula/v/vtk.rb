class Vtk < Formula
  desc "Toolkit for 3D computer graphics, image processing, and visualization"
  homepage "https://www.vtk.org/"
  url "https://www.vtk.org/files/release/9.5/VTK-9.5.2.tar.gz"
  sha256 "cee64b98d270ff7302daf1ef13458dff5d5ac1ecb45d47723835f7f7d562c989"
  license "BSD-3-Clause"
  revision 1
  head "https://gitlab.kitware.com/vtk/vtk.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "eaeffd8adfb0d751affbca472ad5262eb8080cd69a93fba419eea65e4c284e04"
    sha256 cellar: :any,                 arm64_sequoia: "c00bd8996fdeafbc88512f222086aa450f1f337a4032896b0578af4ce1e50d3f"
    sha256 cellar: :any,                 arm64_sonoma:  "2a1607f21b1e98cd23b1ea45bc776d66b1b05387ee7c59f89180f9b10b4fcac9"
    sha256 cellar: :any,                 sonoma:        "f7021fd6e91f4ce36d1b13e5deeda31de64b75781deb00e6486079f5c466c980"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad44c6d5d2195f8cfa98c4e73d8445e939a8e2e70e5534c38f2259f495da05a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73692fd4d3b2f8ac3ef7c57c904d2881f007c448f7407606215ebdd8f5da60cf"
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
  depends_on "python@3.14"
  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "sqlite"
  depends_on "theora"
  depends_on "utf8cpp"
  depends_on "xz"

  uses_from_macos "expat"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gl2ps"
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "mesa"
  end

  def install
    # Work around superenv to avoid mixing `expat` usage in libraries across dependency tree.
    # Brew `expat` usage in Python has low impact as it isn't loaded unless pyexpat is used.
    # TODO: Consider adding a DSL for this or change how we handle Python's `expat` dependency
    if OS.mac? && MacOS.version < :sequoia
      env_vars = %w[CMAKE_PREFIX_PATH HOMEBREW_INCLUDE_PATHS HOMEBREW_LIBRARY_PATHS PATH PKG_CONFIG_PATH]
      ENV.remove env_vars, /(^|:)#{Regexp.escape(Formula["expat"].opt_prefix)}[^:]*/
      ENV.remove "HOMEBREW_DEPENDENCIES", "expat"
    end

    python = "python3.14"
    qml_plugin_dir = lib/"qml/VTK.#{version.major_minor}"
    vtkmodules_dir = prefix/Language::Python.site_packages(python)/"vtkmodules"
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
      -DPython3_EXECUTABLE:FILEPATH=#{which(python)}
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

    system "cmake", ".", "-DCMAKE_BUILD_TYPE=Debug", "-DCMAKE_VERBOSE_MAKEFILE=ON", "-DVTK_DIR=#{vtk_dir}"
    system "make"
    system "./Distance2BetweenPoints"

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
