class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  license all_of: [:public_domain, "GPL-3.0-or-later", "MIT"]

  stable do
    url "https://github.com/ncbi/sra-tools/archive/2.11.1.tar.gz"
    sha256 "725b368562217c145e6e1e062560617fb5f8099d09e64470dffc0873f43636a1"

    resource "ngs-sdk" do
      url "https://github.com/ncbi/ngs/archive/2.11.1.tar.gz"
      sha256 "f39c56bbfdb0bdacdd5e86b5d3b65c448df17e419f3f533b1a0168e99f532553"
    end

    resource "ncbi-vdb" do
      url "https://github.com/ncbi/ncbi-vdb/archive/2.11.1.tar.gz"
      sha256 "21b802205f14a00b084b3fde0984dfb3789def8562b32f8cd09b27547c7b0548"

      # Fix Linux error in vdb3/interfaces/memory/MemoryManagerItf.hpp:155:13:
      # error: 'ptrdiff_t' does not name a type
      patch :DATA
    end
  end

  bottle do
    sha256 cellar: :any, big_sur:      "97051e817f8d0c86278c7b7cebe076cf353e265214f65ec4671f524e2874f96a"
    sha256 cellar: :any, catalina:     "49b626f70a185e51bea31863302ea355a7667389491a285f981483696dba4627"
    sha256 cellar: :any, mojave:       "70e233457d44d8f3c320014aeacda5f8f895a5374a89fcf27b0fd66bdf89f4fc"
    sha256               x86_64_linux: "4f770684c6778372445a3c2568405e17d192f994bdf4892ee596439aeeb9715a"
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
