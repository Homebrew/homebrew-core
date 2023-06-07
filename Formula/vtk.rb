class Vtk < Formula
  desc "Toolkit for 3D computer graphics, image processing, and visualization"
  homepage "https://www.vtk.org/"
  url "https://www.vtk.org/files/release/9.2/VTK-9.2.6.tar.gz"
  sha256 "06fc8d49c4e56f498c40fcb38a563ed8d4ec31358d0101e8988f0bb4d539dd12"
  license "BSD-3-Clause"
  revision 2
  head "https://gitlab.kitware.com/vtk/vtk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "671aeb293c2c62b95a78a148b42d85afb68d99f6f62f803bab2198db86c9b1eb"
    sha256 cellar: :any,                 arm64_monterey: "5a2733edf120861d778505d68726f9f9423884249166c97a41d52b39cd380f64"
    sha256 cellar: :any,                 arm64_big_sur:  "6270716a2021e937f35ab9d5912cbaa1cfc31338f801df1432ea510b0bcd4f9b"
    sha256 cellar: :any,                 ventura:        "0f8c2b2b7671c2195c6682309a8e0197d7ab55efbdea2263bec550bf282ef68f"
    sha256 cellar: :any,                 monterey:       "cf853c07a687d15b24e69d46cbcc8e8173e818722cb58f87b5fddf34f230299f"
    sha256 cellar: :any,                 big_sur:        "4e2462b24482a42d0c10d8981c32d48d802201cd95b66fbcf4074d722bb0c5b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07d6124164f5d8941084e0c9dddfaf3a2cad3233023f62bff2ad3c6a80a85fe8"
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
  depends_on "python@3.11"
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
      -DPython3_EXECUTABLE:FILEPATH=#{which("python3.11")}
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
