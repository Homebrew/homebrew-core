class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  license all_of: [:public_domain, "GPL-3.0-or-later", "MIT"]

  stable do
    url "https://github.com/ncbi/sra-tools/archive/2.11.2.tar.gz"
    sha256 "17ff39d3a905142be63477a206bac3aa76a417e40979f06a8f1eed49fe8c43d4"

    resource "ngs-sdk" do
      url "https://github.com/ncbi/ngs/archive/2.11.2.tar.gz"
      sha256 "7555ab7c2f04bd81160859f6c85c65376dc7f7b891804fad9e7636a7788e39c2"
    end

    resource "ncbi-vdb" do
      url "https://github.com/ncbi/ncbi-vdb/archive/2.11.2.tar.gz"
      sha256 "647efea2762d63dee6d3e462b1fed2ae6d0f2cf1adb0da583ac95f3ee073abdf"

      # Fix Linux error in vdb3/interfaces/memory/MemoryManagerItf.hpp:155:13:
      # error: 'ptrdiff_t' does not name a type
      patch :DATA
    end
  end

  bottle do
    sha256 cellar: :any, big_sur:      "3ae6079cc1870308094b419e8141565c29030e139a2b3dd0065da4a64191a32b"
    sha256 cellar: :any, catalina:     "67df1b84b24a39677517d5f0af6d4d06a99a3aa5c5ae39d3a2af821669868649"
    sha256 cellar: :any, mojave:       "88cdb2651f23202d8f4c97df82e139edfcd2315d2be92021197e9183da007368"
    sha256               x86_64_linux: "f38509ce3f74c56476ae20c67b02ac3f5321ade2eb7c39dc9b24e8ef454c9d12"
  end

  head do
    url "https://github.com/ncbi/sra-tools.git", branch: "master"

    resource "ngs-sdk" do
      url "https://github.com/ncbi/ngs.git", branch: "master"
    end

    resource "ncbi-vdb" do
      url "https://github.com/ncbi/ncbi-vdb.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  # Failed to build with `hdf5` at ncbi-vdb-source/libs/hdf5/hdf5dir.c:295:89:
  # error: too few arguments to function call, expected 5, have 4
  # herr_t h5e = H5Oget_info_by_name( self->hdf5_handle, buffer, &obj_info, H5P_DEFAULT );
  # Try updating to `hdf5` on future release.
  depends_on "hdf5@1.10"
  depends_on "libmagic"

  uses_from_macos "perl" => :build
  uses_from_macos "libxml2"

  def install
    libxml2_prefix = if OS.mac?
      MacOS.sdk_path/"usr"
    else
      Formula["libxml2"].opt_prefix
    end
    with_formula_args = %W[
      --with-hdf5-prefix=#{Formula["hdf5@1.10"].opt_prefix}
      --with-magic-prefix=#{Formula["libmagic"].opt_prefix}
      --with-xml2-prefix=#{libxml2_prefix}
    ]

    ngs_sdk_prefix = buildpath/"ngs-sdk-prefix"
    resource("ngs-sdk").stage do
      cd "ngs-sdk" do
        system "./configure", "--prefix=#{ngs_sdk_prefix}",
                              "--build=#{buildpath}/ngs-sdk-build"
        system "make"
        system "make", "install"
      end
    end

    ncbi_vdb_source = buildpath/"ncbi-vdb-source"
    ncbi_vdb_build = buildpath/"ncbi-vdb-build"
    ncbi_vdb_source.install resource("ncbi-vdb")
    cd ncbi_vdb_source do
      # Fix detection of hdf5 library on macOS as Apple Clang linker doesn't
      # allow mixing static (-Wl,-Bstatic) and dynamic (-Wl,-Bdynamic) libraries
      inreplace "setup/konfigure.perl", "-Wl,-Bstatic -lhdf5 -Wl,-Bdynamic", "-lhdf5" if OS.mac?

      # Fix Linux error: `pshufb' is not supported on `generic64.aes'
      # Upstream ref: https://github.com/ncbi/ncbi-vdb/issues/14
      inreplace "libs/krypto/Makefile", "-Wa,-march=generic64+aes", "" if OS.linux?

      system "./configure", "--prefix=#{buildpath}/ncbi-vdb-prefix",
                            "--build=#{ncbi_vdb_build}",
                            "--with-ngs-sdk-prefix=#{ngs_sdk_prefix}",
                            *with_formula_args
      ENV.deparallelize { system "make" }
    end

    # Fix the error: ld: library not found for -lmagic-static
    # Upstream PR: https://github.com/ncbi/sra-tools/pull/105
    inreplace "tools/copycat/Makefile", "-smagic-static", "-smagic"

    # Fix detection of hdf5 library on macOS as Apple Clang linker doesn't
    # allow mixing static (-Wl,-Bstatic) and dynamic (-Wl,-Bdynamic) libraries
    inreplace "setup/konfigure.perl", "-Wl,-Bstatic -lhdf5 -Wl,-Bdynamic", "-lhdf5" if OS.mac?

    # Fix the error: utf8proc.o: linker input file unused because linking not done
    # Upstream issue: https://github.com/ncbi/sra-tools/issues/283
    if OS.linux?
      inreplace "tools/driver-tool/utf8proc/Makefile",
                "$(CC) $(LDFLAGS) -shared",
                "#{ENV.cc} $(LDFLAGS) -shared"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--build=#{buildpath}/sra-tools-build",
                          "--with-ngs-sdk-prefix=#{ngs_sdk_prefix}",
                          "--with-ncbi-vdb-sources=#{ncbi_vdb_source}",
                          "--with-ncbi-vdb-build=#{ncbi_vdb_build}",
                          *with_formula_args
    system "make", "install"

    # Remove non-executable files.
    rm_r [bin/"magic", bin/"ncbi"]
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
diff --git a/vdb3/interfaces/memory/MemoryManagerItf.hpp b/vdb3/interfaces/memory/MemoryManagerItf.hpp
index d802ba79..84a88aa5 100644
--- a/vdb3/interfaces/memory/MemoryManagerItf.hpp
+++ b/vdb3/interfaces/memory/MemoryManagerItf.hpp
@@ -26,6 +26,7 @@
 #pragma once
 
 #include <memory>
+#include <stddef.h>
 
 namespace VDB3
 {
