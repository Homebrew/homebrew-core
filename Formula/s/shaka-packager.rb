class ShakaPackager < Formula
  desc "Tool and media packaging SDK for DASH and HLS packaging and encryption"
  homepage "https://github.com/shaka-project/shaka-packager"
  license "BSD-3-Clause"
  head "https://github.com/shaka-project/shaka-packager.git", branch: "main"

  stable do
    url "https://github.com/shaka-project/shaka-packager.git",
      tag:      "v3.4.2",
      revision: "c819deaa2376399a89d41f3804bc72f4a20d9d6d"
    # Upgrade libpng to fix 'pngpriv.h:527:16: fatal error: 'fp.h' file not found' error,
    # see: https://github.com/shaka-project/shaka-packager/pull/1507
    on_macos do
      on_tahoe :or_newer do
        patch :DATA

        resource "libpng" do
          url "https://github.com/pnggroup/libpng/archive/2b978915d82377df13fcbb1fb56660195ded868a.tar.gz"
          sha256 "fba1c8e793f01b493f3f47a926862edbfab487ae4240e02ec67131f1e2bf067f"
        end
      end
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    # Remove bundled libpng and replace it with patched version
    if build.stable? && OS.mac? && MacOS.version >= :tahoe
      libpng_source = buildpath/"packager/third_party/libpng/source"
      rm_r libpng_source
      libpng_source.install resource("libpng")
    end

    args = %w[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DBUILD_SHARED_LIBS=OFF
      -DFULLY_STATIC=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *args, *std_cmake_args
    system "cmake", "--build", "build", "--config", "Release"
    system "cmake", "--install", "build", "--strip", "--config", "Release"
  end

  test do
    resource "testdata" do
      url "https://github.com/mediaelement/mediaelement-files/raw/refs/heads/master/big_buck_bunny.mp4"
      sha256 "543a4ad9fef4c9e0004ec9482cb7225c2574b0f889291e8270b1c4d61dbc1ab8"
    end

    resource("testdata").stage do
      assert_match "Packaging completed successfully", shell_output("#{bin}/packager \
        input=big_buck_bunny.mp4,stream=video,output=big_buck_bunny.mp4 \
        --enable_raw_key_decryption \
        --keys label=SD:key=6143b5373a51cb46209cfed0d747da66:key_id=2c7ed98f472124deafe1dfeba2b45a34")
    end
  end
end

__END__
From 7cd7e48e9cfd008542c2f7c7c292bde15837a15e Mon Sep 17 00:00:00 2001
From: Joey Parrish <joeyparrish@users.noreply.github.com>
Date: Fri, 21 Nov 2025 11:13:11 -0800
Subject: [PATCH] fix: Upgrade libpng to fix build on new macs (#1507)

This upgrades libpng from v1.6.37 to v1.6.50

This newer libpng doesn't assume the existence of fp.h on Mac (which
isn't present on newer ones), but the CMake options for libpng changed
and had to be adjusted somewhat.
---
 .github/workflows/build.yaml               | 1 +
 packager/third_party/CMakeLists.txt        | 3 ++-
 packager/third_party/libpng/CMakeLists.txt | 8 ++++----
 packager/third_party/libpng/source         | 2 +-
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/.github/workflows/build.yaml b/.github/workflows/build.yaml
index 4d929259f045f5a57a3ee00ec092de83692de473..cfe84e3b0c2d4da467758ba890629162b94b3797 100644
--- a/.github/workflows/build.yaml
+++ b/.github/workflows/build.yaml
@@ -199,6 +199,7 @@ jobs:
           fi

           cmake \
+            -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
             -DCMAKE_BUILD_TYPE="${{ matrix.build_type }}" \
             -DBUILD_SHARED_LIBS="$BUILD_SHARED_LIBS" \
             -DFULLY_STATIC="$FULLY_STATIC" \
diff --git a/packager/third_party/CMakeLists.txt b/packager/third_party/CMakeLists.txt
index c883c0b7eb35e87ca53e27a9bd24e7a72b7e46f0..51f8585ccea040774abc4e35b6f97d01972904c7 100644
--- a/packager/third_party/CMakeLists.txt
+++ b/packager/third_party/CMakeLists.txt
@@ -42,6 +42,8 @@ add_subdirectory(c-ares EXCLUDE_FROM_ALL)
 add_subdirectory(curl EXCLUDE_FROM_ALL)
 add_subdirectory(googletest EXCLUDE_FROM_ALL)
 add_subdirectory(json EXCLUDE_FROM_ALL)
+# NOTE: libpng references zlib, so put zlib before libpng
+add_subdirectory(zlib EXCLUDE_FROM_ALL)
 add_subdirectory(libpng EXCLUDE_FROM_ALL)
 add_subdirectory(libwebm EXCLUDE_FROM_ALL)
 add_subdirectory(libxml2 EXCLUDE_FROM_ALL)
@@ -49,4 +51,3 @@ add_subdirectory(mbedtls EXCLUDE_FROM_ALL)
 add_subdirectory(mimalloc EXCLUDE_FROM_ALL)
 add_subdirectory(mongoose EXCLUDE_FROM_ALL)
 add_subdirectory(protobuf EXCLUDE_FROM_ALL)
-add_subdirectory(zlib EXCLUDE_FROM_ALL)
diff --git a/packager/third_party/libpng/CMakeLists.txt b/packager/third_party/libpng/CMakeLists.txt
index c9d33a828ca29862d4090101e56be3ef0260653a..02c3ad6f36305ca19c4e8156480462a9d45e29db 100644
--- a/packager/third_party/libpng/CMakeLists.txt
+++ b/packager/third_party/libpng/CMakeLists.txt
@@ -19,12 +19,12 @@ set(PNG_DEBUG OFF)
 # Don't install anything.
 set(SKIP_INSTALL_ALL ON)

-# A confusing name, but this means "let us tell you where to find zlib".
-set(PNG_BUILD_ZLIB ON)
-# Tell libpng where to find zlib headers.
+# Tell libpng where to find zlib.
+set(ZLIB_FOUND TRUE)
 set(ZLIB_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../zlib/source/")
-# Tell libpng where to find zlib library to link to.
 set(ZLIB_LIBRARY zlibstatic)
+add_library(ZLIB::ZLIB ALIAS zlibstatic)
+
 # Tell libpng where to find libm on Linux (-lm).
 set(M_LIBRARY m)
