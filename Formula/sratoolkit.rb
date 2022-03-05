class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  license all_of: [:public_domain, "GPL-3.0-or-later", "MIT"]

  stable do
    url "https://github.com/ncbi/sra-tools/archive/2.11.3.tar.gz"
    sha256 "6339dc398e04505cc7aa889e0266713e2b9dbd2309300e6fba62874051ca144d"

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

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, monterey:     "7288ce0e3eca352589f120ae8a24f60009bd5ee7ad7b5fcd3ef68960ee0cb144"
    sha256 cellar: :any, big_sur:      "3ed43023475647f878bc0876f69ed16e46dee7eea3d6ebcbd5fa1e5e8849f4ce"
    sha256 cellar: :any, catalina:     "70d22bb73b4f8745df4434b20adbd0cd02b88cd136223deb5409ed24e944516f"
    sha256               x86_64_linux: "2f713ec90a39a271b1a809e25c12f6d4749eb2cd3a20072138f9c87f2be6f5d7"
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
