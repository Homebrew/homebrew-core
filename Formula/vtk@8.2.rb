class VtkAT82 < Formula
  desc "Toolkit for 3D computer graphics, image processing, and visualization"
  homepage "https://www.vtk.org/"
  url "https://www.vtk.org/files/release/8.2/VTK-8.2.0.tar.gz"
  sha256 "34c3dc775261be5e45a8049155f7228b6bd668106c72a3c435d95730d17d57bb"
  license "BSD-3-Clause"
  revision 7

  bottle do
    rebuild 1
    sha256                               arm64_monterey: "ee325de2481066de0d5a310681be27d8b69075761de970b03c3ac5d4f623fa94"
    sha256                               arm64_big_sur:  "5ada273760e541d09da596b14552ce792ee9844a243b592a7fae76e988df4714"
    sha256                               monterey:       "c99f5d89e48984c565431fdcd66fa30a95fea2f2939738d7b809d052cbfba3e0"
    sha256                               big_sur:        "f588c1f6c99f842c807a440bfeebd7b2411dadec4c869f2348348668054ca2a8"
    sha256                               catalina:       "5fbc2c1c449782fe77a92febe6872dee0b2487e5da4462f3255318e84e1a9292"
    sha256                               mojave:         "5509812315e9589e0adeff8b780bab961ee9d89233179653d508d8a9f620977b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13f56b55f3986c1892cfc9161fec794b45a0d4a25bc481346695bee510ae897a"
  end

  keg_only :versioned_formula

  deprecate! date: "2020-05-14", because: :versioned_formula

  depends_on "cmake" => [:build, :test]
  depends_on "boost"
  depends_on "fontconfig"
  depends_on "hdf5"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "netcdf"
  depends_on "pyqt@5"
  depends_on "python@3.9"
  depends_on "qt@5"

  uses_from_macos "expat"
  uses_from_macos "libxml2"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
    depends_on "icu4c"
    depends_on "libxt"
    depends_on "szip"
    depends_on "mesa-glu"
  end

  fails_with gcc: "5"

  # TODO: use diff
  # Fix compile issues on Mojave and later
  patch do
    url "https://gitlab.kitware.com/vtk/vtk/commit/ca3b5a50d945b6e65f0e764b3138cad17bd7eb8d.diff"
    sha256 "b9f7a3ebf3c29f3cad4327eb15844ac0ee849755b148b60fef006314de8e822e"
  end

  # Python 3.8 compatibility
  patch do
    url "https://gitlab.kitware.com/vtk/vtk/commit/257b9d7b18d5f3db3fe099dc18f230e23f7dfbab.diff"
    sha256 "572c06a4ba279a133bfdcf0190fec2eff5f330fa85ad6a2a0b0f6dfdea01ca69"
  end

  # Qt 5.15 support
  patch do
    url "https://gitlab.kitware.com/vtk/vtk/-/commit/797f28697d5ba50c1fa2bc5596af626a3c277826.diff"
    sha256 "cb3b3a0e6978889a9cb95be35f3d4a6928397d3b843ab72ecaaf96554c6d4fc7"
  end

  # GCC 11 support
  patch do
    url "https://gitlab.kitware.com/vtk/vtk/-/commit/c83b583cc06e375c320a4980d2104b8d1e7fbfde.diff"
    sha256 "becf3a21c6f768dc378b598eb87a0e11258cdb8bdd69930784696823408498c6"
  end

  def install
    # Do not record compiler path because it references the shim directory
    inreplace "Common/Core/vtkConfigure.h.in", "@CMAKE_CXX_COMPILER@", "clang++"

    # Fix build with GCC 10 or newer
    # Adapted from https://bugs.gentoo.org/attachment.cgi?id=641488&action=diff
    inreplace "CMake/VTKGenerateExportHeader.cmake", "[3-9]", "[1-9][0-9]" if OS.linux?

    pyver = Language::Python.major_minor_version "python3"
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_TESTING=OFF
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      -DCMAKE_INSTALL_RPATH:STRING=#{lib}
      -DModule_vtkInfovisBoost=ON
      -DModule_vtkInfovisBoostGraphAlgorithms=ON
      -DModule_vtkRenderingFreeTypeFontConfig=ON
      -DVTK_REQUIRED_OBJCXX_FLAGS=''
      -DVTK_USE_SYSTEM_EXPAT=ON
      -DVTK_USE_SYSTEM_HDF5=ON
      -DVTK_USE_SYSTEM_JPEG=ON
      -DVTK_USE_SYSTEM_LIBXML2=ON
      -DVTK_USE_SYSTEM_NETCDF=ON
      -DVTK_USE_SYSTEM_PNG=ON
      -DVTK_USE_SYSTEM_TIFF=ON
      -DVTK_USE_SYSTEM_ZLIB=ON
      -DVTK_WRAP_PYTHON=ON
      -DVTK_PYTHON_VERSION=3
      -DPYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3
      -DVTK_INSTALL_PYTHON_MODULE_DIR=#{lib}/python#{pyver}/site-packages
      -DVTK_QT_VERSION:STRING=5
      -DVTK_Group_Qt=ON
      -DVTK_WRAP_PYTHON_SIP=ON
      -DSIP_PYQT_DIR='#{Formula["pyqt5"].opt_share}/sip'
    ]

    args << "-DVTK_USE_COCOA=ON" if OS.mac?

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    # Avoid hard-coding HDF5's Cellar path
    inreplace Dir["#{lib}/cmake/**/vtkhdf5.cmake"].first,
              Formula["hdf5"].prefix.realpath,
              Formula["hdf5"].opt_prefix

    # get rid of bad include paths on 10.14+
    if MacOS.version >= :mojave
      inreplace Dir["#{lib}/cmake/vtk-*/Modules/vtklibxml2.cmake"], %r{;/Library/Developer/CommandLineTools[^"]*}, ""
      inreplace Dir["#{lib}/cmake/vtk-*/Modules/vtkexpat.cmake"], %r{;/Library/Developer/CommandLineTools[^"]*}, ""
      inreplace Dir["#{lib}/cmake/vtk-*/Modules/vtkzlib.cmake"], %r{;/Library/Developer/CommandLineTools[^"]*}, ""
      inreplace Dir["#{lib}/cmake/vtk-*/Modules/vtkpng.cmake"], %r{;/Library/Developer/CommandLineTools[^"]*}, ""
    end

    # Prevent dependents from using fragile Cellar paths
    inreplace_cmake_modules = [
      lib/"cmake/vtk-#{version.major_minor}/VTKConfig.cmake",
      lib/"cmake/vtk-#{version.major_minor}/Modules/vtkPython.cmake",
    ]
    inreplace_cmake_modules << (lib/"cmake/vtk-#{version.major_minor}/VTKTargets-release.cmake") if OS.mac?

    inreplace inreplace_cmake_modules, prefix, opt_prefix
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
      set(CMAKE_INSTALL_RPATH "#{Formula["vtk@8.2"].opt_lib}")
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
