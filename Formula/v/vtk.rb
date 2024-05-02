class Vtk < Formula
  desc "Toolkit for 3D computer graphics, image processing, and visualization"
  homepage "https://www.vtk.org/"
  url "https://www.vtk.org/files/release/9.3/VTK-9.3.0.tar.gz"
  sha256 "fdc7b9295225b34e4fdddc49cd06e66e94260cb00efee456e0f66568c9681be9"
  license "BSD-3-Clause"
  revision 1
  head "https://gitlab.kitware.com/vtk/vtk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c8ae19fbf749f82012080c3aef6c77237bc1c8835beeb28e4d44c2985ea9d2e2"
    sha256 cellar: :any,                 arm64_ventura:  "de240e0547591ac35b9c7a1e645f2ecf3bf332f594d32bd9bb4a76e0ece70d65"
    sha256 cellar: :any,                 arm64_monterey: "4e0565232dc404dbab93c5ce83f3f446d20cfd0c3dc50877d21c18d635fc9bfa"
    sha256 cellar: :any,                 sonoma:         "4e0feb2f33a4aa810c043097b11b592338b6a7f2ba3219370ac399a909c63982"
    sha256 cellar: :any,                 ventura:        "700934ee8f56281cbb57f5228110af0cdebbf3c59f61f83dfc6c224dd92437ae"
    sha256 cellar: :any,                 monterey:       "2845693a9100d2808dd4d81bbbc88fdaa01c0ad98784c580f34777d90651cdfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51cf47c587e90d6b46a1f7e5404789d13ca0fb0be57c03f254d484762dfb3327"
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
  depends_on "python@3.12"
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

    python = "python3.12"
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
