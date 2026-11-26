class Vtk < Formula
  desc "Toolkit for 3D computer graphics, image processing, and visualization"
  homepage "https://www.vtk.org/"
  url "https://www.vtk.org/files/release/9.7/VTK-9.7.2.tar.gz"
  sha256 "fecef55df5caec6298ce190024060a90ce3bb515033c0f18968b9ab5c12bf796"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 5
  head "https://gitlab.kitware.com/vtk/vtk.git", branch: "master"

  livecheck do
    url "https://vtk.org/download/"
    regex(/href=.*?vtk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "cb1f90af8d3448a7449935cb126f21ec2068eb73498d384df1b19536c062203c"
    sha256 cellar: :any, arm64_golden_gate: "a983374364f2eea2bb17e0e347f6bdbe1a3f6f1d967bf86bc517c90b3abe8bd0"
    sha256 cellar: :any, arm64_tahoe:       "de228c109396cd8151cac4611acd7a82b7771f6b0da7fd390ee7784906d804fb"
    sha256 cellar: :any, arm64_sequoia:     "0c2361cac87d951a16c02368f8895746fd27271e626449ec4f748def7840bc83"
    sha256 cellar: :any, arm64_linux:       "a8dc5727f64d705655b966bfd2e8fce6d4d6640296286b2db215d224cb263044"
    sha256 cellar: :any, x86_64_linux:      "46b55bb5601ef21e2a302d094cac1e7ae159d716a34bf64b2dd399e422e4a240"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "eigen" => :build
  depends_on "utf8cpp" => :build
  depends_on "pyqt" => :test
  depends_on "boost" => :no_linkage
  depends_on "cgns"
  depends_on "fast_float" => :no_linkage
  depends_on "fmt"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gl2ps"
  depends_on "hdf5"
  depends_on "jpeg-turbo"
  depends_on "jsoncpp"
  depends_on "libharu"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "lz4"
  depends_on "netcdf"
  depends_on "nlohmann-json" => :no_linkage
  depends_on "proj"
  depends_on "pugixml"
  depends_on "python@3.15"
  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "scnlib"
  depends_on "sqlite"
  depends_on "theora"
  depends_on "verdict"
  depends_on "xz"

  uses_from_macos "expat", since: :sequoia
  uses_from_macos "libxml2"

  on_linux do
    depends_on "libx11" => :no_linkage # dlopen by vtkX11Functions
    depends_on "libxcursor" => :no_linkage # dlopen by vtkX11Functions
    depends_on "mesa" => :no_linkage # dlopen by vtkglad
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
    vtkmodules_dir = prefix/Language::Python.site_packages(python3)/"vtkmodules"
    rpaths = [rpath, rpath(source: vtkmodules_dir)]

    # Using bundled pegtl for 3.x API
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}
      -DPython3_EXECUTABLE=#{python3}
      -DVTK_GROUP_ENABLE_Qt=YES
      -DVTK_MODULE_ENABLE_VTK_InfovisBoost=YES
      -DVTK_MODULE_ENABLE_VTK_InfovisBoostGraphAlgorithms=YES
      -DVTK_MODULE_ENABLE_VTK_RenderingFreeTypeFontConfig=YES
      -DVTK_MODULE_USE_EXTERNAL_VTK_exprtk=OFF
      -DVTK_MODULE_USE_EXTERNAL_VTK_ioss=OFF
      -DVTK_MODULE_USE_EXTERNAL_VTK_pegtl=OFF
      -DVTK_MODULE_USE_EXTERNAL_VTK_token=OFF
      -DVTK_USE_EXTERNAL=ON
      -DVTK_VERSIONED_INSTALL=OFF
      -DVTK_WRAP_PYTHON=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    vtk_dir = lib/"cmake/vtk"
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
