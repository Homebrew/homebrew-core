class Veraxx < Formula
  desc "Programmable tool for C++ source code"
  homepage "https://bitbucket.org/verateam/vera"
  url "https://bitbucket.org/verateam/vera/downloads/vera++-1.3.0.tar.gz"
  sha256 "9415657a09438353489db10ca860dd6459e446cfd9c649a1a2e02268da66f270"
  license "BSL-1.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fb1646c3a9cb8a0707a2674d546b6db25dcbea0fffd7461358c43247ae35ddcc"
    sha256 cellar: :any_skip_relocation, big_sur:       "f28290171b8cc68f972b3cdbf811c1491d4be7dd8307fe1551dbfbdbc38269ba"
    sha256 cellar: :any_skip_relocation, catalina:      "985e75bcd4c9a559fd2e2841d10d0cb3d73fdc940a76aa3d3050514017d61560"
    sha256 cellar: :any_skip_relocation, mojave:        "41254f89a2510f8c3f39718a2068a9000658ca714ee104fd426a1cc4d7afd8e7"
    sha256 cellar: :any_skip_relocation, high_sierra:   "73b49e98703b820ffc65213f2e14d0932c5b08851165042811b3e3318bbc84f6"
    sha256 cellar: :any_skip_relocation, sierra:        "3a261328afd43c8c38f33802ced93557c58ae8903dab90e0ca4546004003447f"
    sha256 cellar: :any_skip_relocation, el_capitan:    "76dcb0b9340b8fc9413fc848dff27e8805d7b2a9c63d5128fc83ce5bd3bd1cd5"
    sha256 cellar: :any_skip_relocation, yosemite:      "a2620392e9204964ecd0ec0bc6b90268d27e5e2a28ef304aff3d3719ed058b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad710a6d70551b2d74732c9774a926f8a3c63f2db1aa87373701cfc90039d996"
  end

  depends_on "cmake" => :build

  uses_from_macos "tcl-tk"

  # Use prebuilt docs to avoid need for pandoc
  resource "doc" do
    url "https://bitbucket.org/verateam/vera/downloads/vera++-1.3.0-doc.tar.gz"
    sha256 "122a15e33a54265d62a6894974ca2f0a8f6ff98742cf8e6152d310cc23099400"
  end

  # Custom-built boost, lua, and luabind are used by the build scripts
  resource "boost" do
    url "https://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.tar.bz2"
    sha256 "f0397ba6e982c4450f27bf32a2a83292aba035b827a5623a14636ea583318c41"
  end

  resource "lua" do
    url "https://github.com/LuaDist/lua/archive/5.2.3.tar.gz"
    sha256 "c8aa2c74e8f31861cea8f030ece6b6cb18974477bd1e9e1db4c01aee8f18f5b6"
  end

  resource "luabind" do
    url "https://github.com/verateam/luabind/archive/vera-1.3.0.tar.gz"
    sha256 "7d93908b7d978e44ebe5dfad6624e6daa033f284a5f24013f37cac162a18f71a"
  end

  # Fix Python detection.
  patch :DATA

  def install
    resource("boost").stage do
      system "./bootstrap.sh", "--prefix=#{buildpath}/3rdParty",
             "--with-libraries=filesystem,system,program_options,regex,wave,python"
      system "./b2", "install", "threading=multi", "link=static", "warnings=off",
             "cxxflags=-DBOOST_WAVE_SUPPORT_MS_EXTENSIONS=1", "-s NO_BZIP2=1"
    end

    resource("lua").stage do
      args = std_cmake_args
      args << "-DBUILD_SHARED_LIBS:BOOL=OFF"
      args << "-DCMAKE_INSTALL_PREFIX:PATH=#{buildpath}/3rdParty"
      system "cmake", ".", *args
      system "make", "install"
    end

    resource("luabind").stage do
      args = std_cmake_args
      args << "-DBUILD_TESTING:BOOL=OFF"
      args << "-DLUA_INCLUDE_DIR:PATH=#{buildpath}/3rdParty/include"
      args << "-DLUA_LIBRARIES:PATH=#{buildpath}/3rdParty/lib/liblua.a"
      args << "-DBOOST_ROOT:PATH=#{buildpath}/3rdParty"
      args << "-DCMAKE_INSTALL_PREFIX:PATH=#{buildpath}/3rdParty"
      system "cmake", ".", *args
      system "make", "install"
    end

    args = std_cmake_args + %W[
      -DVERA_USE_SYSTEM_BOOST:BOOL=ON
      -DBoost_USE_STATIC_LIBS:BOOL=ON
      -DLUA_INCLUDE_DIR:PATH=#{buildpath}/3rdParty/include
      -DLUA_LIBRARIES:PATH=#{buildpath}/3rdParty/lib/liblua.a
      -DLUA_LIBRARY:PATH=#{buildpath}/3rdParty/lib/liblua.a
      -DLUABIND_INCLUDE_DIR:PATH=#{buildpath}/3rdParty/include
      -DLUABIND_LIBRARIES:PATH=#{buildpath}/3rdParty/lib/libluabind.a
      -DLUABIND_LIBRARY:PATH=#{buildpath}/3rdParty/lib/libluabind.a
      -DBoost_INCLUDE_DIR:PATH=#{buildpath}/3rdParty/include
      -DBoost_LIBRARY_DIR_RELEASE:PATH=#{buildpath}/3rdParty/lib
    ]
    if OS.linux?
      # Disable building Python rules support since vera++ needs Python 2.
      # Revisit on release with Python 3: https://bitbucket.org/verateam/vera/issues/108/migrate-to-python-3
      args << "-DVERA_PYTHON=OFF"
    end
    system "cmake", ".", *args
    system "make", "install"

    resource("doc").stage do
      man1.install "vera++.1"
      doc.install "vera++.html"
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/vera++ --version").strip
  end
end
__END__
diff --git a/src/boost.cmake b/src/boost.cmake
index 797cb60..d8c51c8 100644
--- a/src/boost.cmake
+++ b/src/boost.cmake
@@ -8,7 +8,16 @@ mark_as_advanced(VERA_USE_SYSTEM_BOOST)
 
 set(boostLibs filesystem system program_options regex wave)
 if(VERA_PYTHON)
-  list(APPEND boostLibs python)
+  # Note that Boost Python components require a Python version
+  # suffix (Boost 1.67 and later), e.g. python36 or python27 for
+  # the versions built against Python 3.6 and 2.7, respectively.
+  # This also applies to additional components using Python
+  # including mpi_python and numpy. Earlier Boost releases may use
+  # distribution-specific suffixes such as 2, 3 or 2.7. These may also
+  # be used as suffixes, but note that they are not portable.
+  #
+  # from https://cmake.org/cmake/help/latest/module/FindBoost.html
+  list(APPEND boostLibs python27)
 endif()
 
 if(VERA_USE_SYSTEM_BOOST)
@@ -40,6 +49,7 @@ else()
   set(SOURCEFORGE downloads.sourceforge.net CACHE STRING
     "Sourceforge host used to download external projects. Use it to force a specific mirror.")
   mark_as_advanced(SOURCEFORGE)
+  string(REPLACE "python27" "python" boostLibs "${boostLibs}")
   string(REPLACE ";" "," boostLibsComma "${boostLibs}")
   string(REPLACE ";" " --with-" WITH_LIBS "${boostLibs}")
   set(WITH_LIBS "--with-${WITH_LIBS}")
diff --git a/src/python.cmake b/src/python.cmake
index 9df6892..ba4210f 100644
--- a/src/python.cmake
+++ b/src/python.cmake
@@ -4,8 +4,8 @@ mark_as_advanced(VERA_USE_SYSTEM_PYTHON)
 
 if(VERA_USE_SYSTEM_PYTHON)
   set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR})
-  find_package(PythonInterp 2.0)
-  find_package(PythonLibs 2.0)
+  find_package(PythonInterp 2.7)
+  find_package(PythonLibs 2.7)
   if(WIN32 AND NOT PYTHONLIBS_FOUND)
     message(FATAL_ERROR "Could NOT find Python. Turn VERA_USE_SYSTEM_PYTHON to OFF to build it with vera++.")
   endif()
