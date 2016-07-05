class Tao < Formula
  desc "CORBA C++ implementation"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/TAO.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE+TAO-6.4.0.tar.bz2"
  sha256 "8177d4f16bf013f7a003a7d1f83de9fda646406754c1f4cc0b0964a4b839eb0f"

  def install
    name = MacOS.cat.to_s.delete "_"
    ln_sf "config-macosx-#{name}.h", "ace/config.h"
    ln_sf "platform_macosx_#{name}.GNU", "include/makeinclude/platform_macros.GNU"

    ENV["ACE_ROOT"] = buildpath
    ENV["TAO_ROOT"] = "#{buildpath}/TAO"
    ENV["DYLD_LIBRARY_PATH"] = "#{buildpath}/lib"

    system "make", "-C", "ace", "-f", "GNUmakefile",
                   "INSTALL_PREFIX=#{prefix}",
                   "DESTDIR=",
                   "INST_DIR=/ace",
                   "debug=0",
                   "shared_libs=1",
                   "static_libs=0",
                   "install"

    system "make", "-C", "ace", "apps", "gperf", "src", "-f", "GNUmakefile.gperf",
                   "INSTALL_PREFIX=#{prefix}",
                   "DESTDIR=",
                   "INST_DIR=/ace",
                   "debug=0",
                   "shared_libs=1",
                   "static_libs=0",
                   "install"

    system "make", "-C", "TAO", "TAO/IDL", "-f", "GNUmakefile",
                   "INSTALL_PREFIX=#{prefix}",
                   "LDFLAGS=",
                   "DESTDIR=",
                   "INST_DIR=/tao",
                   "debug=0",
                   "shared_libs=1",
                   "static_libs=0",
                   "install"

    system "make", "-C", "TAO", "tao", "-f", "GNUmakefile",
                   "INSTALL_PREFIX=#{prefix}",
                   "LDFLAGS=",
                   "DESTDIR=",
                   "INST_DIR=/tao",
                   "debug=0",
                   "shared_libs=1",
                   "static_libs=0",
                   "install"

    system "make", "-C", "TAO", "tests", "hello", "-f", "GNUmakefile",
                   "INSTALL_PREFIX=#{prefix}",
                   "LDFLAGS=",
                   "DESTDIR=",
                   "INST_DIR=/tao",
                   "debug=0",
                   "shared_libs=1",
                   "static_libs=0",
                   "install"
  end

  test do
    cp_r "#{pkgshare}/tests/hello/.", testpath
    system "./run_test.pl"
  end
end
