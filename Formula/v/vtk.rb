class Vtk < Formula
  desc "Toolkit for 3D computer graphics, image processing, and visualization"
  homepage "https://www.vtk.org/"
  url "https://www.vtk.org/files/release/9.4/VTK-9.4.2.tar.gz"
  sha256 "36c98e0da96bb12a30fe53708097aa9492e7b66d5c3b366e1c8dc251e2856a02"
  license "BSD-3-Clause"
  revision 2
  head "https://gitlab.kitware.com/vtk/vtk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:  "7bd0f3277f5b5e0a32468b7a217d42703d51eede487af1e142ce4af4333b18a5"
    sha256 cellar: :any, arm64_ventura: "9f7c34e67f1ac30dcd36baaa09546ef1a8de1dfe18d1245eefc693e84daa0c1c"
    sha256 cellar: :any, sonoma:        "32b9f5cad19c8be10c590f81e34c9d38b9d832c7ea839e7a3b86c99459aa7619"
    sha256 cellar: :any, ventura:       "9a6f83aa6cde46ef953b30ab039e69e8106e077464774017c592a25ddbaa21a2"
    sha256               x86_64_linux:  "410b300ff9d879d6e4f85f145f870b1279095d098e9abca12f601449dc6a5610"
  end

  depends_on "cmake" => [:build, :test]
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
  depends_on "pyqt"
  depends_on "python@3.13"
  depends_on "qt"
  depends_on "sqlite"
  depends_on "theora"
  depends_on "utf8cpp"
  depends_on "xz"

  uses_from_macos "expat"
  uses_from_macos "libxml2"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gl2ps"
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "mesa"
  end

  # Apply Arch Linux patch to fix build with netcdf 4.9.3+
  # Issue ref: https://gitlab.kitware.com/vtk/vtk/-/issues/19616
  patch do
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/vtk/-/raw/b4d07bd7ee5917e2c32f7f056cf78472bcf1cec2/netcdf-4.9.3.patch"
    sha256 "87535578bbb0023ede506fd64afae95cdf4fb698c543f9735e6267730634afbc"
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

    python = "python3.13"
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
  end
end
