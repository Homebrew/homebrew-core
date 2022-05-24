class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  license all_of: [:public_domain, "GPL-3.0-or-later", "MIT"]

  stable do
    url "https://github.com/ncbi/sra-tools/archive/refs/tags/3.0.0.tar.gz"
    sha256 "b6e8116ecb196b91d5ee404cc978a128eec9af24bdc96f57ff7ebfaf9059a760"

    resource "ncbi-vdb" do
      url "https://github.com/ncbi/ncbi-vdb/archive/refs/tags/3.0.0.tar.gz"
      sha256 "154317ef265104861fe8d3d2e439939ae98f33b1e28da3c45f32ae8534dbfad7"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "975b3b4963eb43aa4c18bd4c95f9b7620f07938990a85cf305f7dcf48684a085"
    sha256 cellar: :any,                 arm64_big_sur:  "42d4d3f558d41d974c07d7ec7c7d025f1b227c8f9cafedb94c2d030dfb9a12a5"
    sha256 cellar: :any,                 monterey:       "a88822cbdf8bf72d39325a1ebd26bf0a30460a1dbc2d597ca67613a35a140116"
    sha256 cellar: :any,                 big_sur:        "4a01bbc8741c610ec13d056e23797718b46f991b2a30bc329807c90aaabdb153"
    sha256 cellar: :any,                 catalina:       "ecc6b82054036d2ff55ddab7959ea7a8ee6d6d4ff8624a7ca332cace87293129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0bc8bd79688b0ca4a7d2ca33f9b8a9e400198b0f6a863f3572c78032c0e6ce8"
  end

  head do
    url "https://github.com/ncbi/sra-tools.git", branch: "master"

    resource "ncbi-vdb" do
      url "https://github.com/ncbi/ncbi-vdb.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  uses_from_macos "libxml2"

  # Modify cmake scripts to avoid building tests when BUILD_TESTING=OFF and
  # to install into CMAKE_INSTALL_LIBDIR rather than CMAKE_INSTALL_PREFIX/lib64.
  # Issue ref: https://github.com/ncbi/sra-tools/issues/638
  # Issue ref: https://github.com/ncbi/sra-tools/issues/639
  patch :DATA

  def install
    (buildpath/"ncbi-vdb-source").install resource("ncbi-vdb")

    # Workaround to allow clang/aarch64 build to use the gcc/arm64 directory
    # Issue ref: https://github.com/ncbi/ncbi-vdb/issues/65
    ln_s "../gcc/arm64", buildpath/"ncbi-vdb-source/interfaces/cc/clang/aarch64" if Hardware::CPU.arm?

    # Workaround to remove hardcoded bitmagic SSE4.2 optimization if needed
    if !Hardware::CPU.intel? || !Hardware::CPU.sse4_2? || (build.bottle? && !MacOS.version.requires_sse42?)
      bitmagic_opt = Hardware::CPU.arm? ? "-DDBMNEONOPT" : "-DBMSSE2OPT"
      inreplace "tools/sharq/CMakeLists.txt", "add_definitions(-msse4.2 -DBMSSE42OPT)",
                                              "add_definitions(#{bitmagic_opt})"
    end

    # Need to use HDF 1.10 API: error: too few arguments to function call, expected 5, have 4
    # herr_t h5e = H5Oget_info_by_name( self->hdf5_handle, buffer, &obj_info, H5P_DEFAULT );
    ENV.append_to_cflags "-DH5_USE_110_API"

    system "cmake", "-S", "ncbi-vdb-source", "-B", "ncbi-vdb-build", *std_cmake_args,
                    "-DNGS_INCDIR=#{buildpath}/ngs/ngs-sdk"
    system "cmake", "--build", "ncbi-vdb-build"

    system "cmake", "-S", ".", "-B", "sra-tools-build", *std_cmake_args,
                    "-DVDB_BINDIR=#{buildpath}/ncbi-vdb-build",
                    "-DVDB_LIBDIR=#{buildpath}/ncbi-vdb-build/lib",
                    "-DVDB_INCDIR=#{buildpath}/ncbi-vdb-source/interfaces"
    system "cmake", "--build", "sra-tools-build"
    system "cmake", "--install", "sra-tools-build"

    # Remove non-executable files.
    (bin/"magic").unlink if OS.linux?
    (bin/"ncbi").rmtree
  end

  test do
    # For testing purposes, generate a sample config noninteractively in lieu of running vdb-config --interactive
    # See upstream issue: https://github.com/ncbi/sra-tools/issues/291
    require "securerandom"
    mkdir ".ncbi"
    (testpath/".ncbi/user-settings.mkfg").write "/LIBS/GUID = \"#{SecureRandom.uuid}\"\n"

    assert_match "Read 1 spots for SRR000001", shell_output("#{bin}/fastq-dump -N 1 -X 1 SRR000001")
    assert_match "@SRR000001.1 EM7LVYS02FOYNU length=284", File.read("SRR000001.fastq")
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index d54d4646..ba4b77b7 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -51,7 +51,9 @@ add_subdirectory( ngs )
 add_subdirectory( libs )
 add_subdirectory( tools )

-add_subdirectory( test )
+if (BUILD_TESTING)
+	add_subdirectory( test )
+endif()

 set ( CPACK_PACKAGE_NAME sra-tools )
 set ( CPACK_PACKAGE_VERSION 0.1 )
diff --git a/build/env.cmake b/build/env.cmake
index 1c7a317a..e975d74c 100755
--- a/build/env.cmake
+++ b/build/env.cmake
@@ -362,7 +362,7 @@ function( ExportStatic name install )
                             ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/lib${name}.a.${MAJVERS}
                             ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/lib${name}.a
                             ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/lib${name}-static.a
-                    DESTINATION ${CMAKE_INSTALL_PREFIX}/lib64
+                    DESTINATION ${CMAKE_INSTALL_LIBDIR}
             )
          endif()
     else()
@@ -371,7 +371,7 @@ function( ExportStatic name install )
         set_target_properties( ${name} PROPERTIES
             ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE})
         if ( ${install} )
-            install( TARGETS ${name} DESTINATION ${CMAKE_INSTALL_PREFIX}/lib64 )
+            install( TARGETS ${name} DESTINATION ${CMAKE_INSTALL_LIBDIR} )
         endif()
     endif()
 endfunction()
@@ -408,7 +408,7 @@ function(MakeLinksShared target name install)
             install( PROGRAMS  ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/lib${name}${LIBSUFFIX}
                             ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/lib${name}${MAJLIBSUFFIX}
                             ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/lib${name}.${SHLX}
-                    DESTINATION ${CMAKE_INSTALL_PREFIX}/lib64
+                    DESTINATION ${CMAKE_INSTALL_LIBDIR}
         )
         endif()
     else()
@@ -581,7 +581,7 @@ if ( SINGLE_CONFIG )
                 ${CMAKE_INSTALL_PREFIX}/bin/ncbi    \
                 /etc/ncbi                           \
                 ${CMAKE_INSTALL_PREFIX}/bin         \
-                ${CMAKE_INSTALL_PREFIX}/lib64       \
+                ${CMAKE_INSTALL_LIBDIR}             \
                 ${CMAKE_SOURCE_DIR}/shared/kfgsums  \
             \" )"
     )
