class Tao < Formula
  desc "TAO, the C++ CORBA implementation"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/TAO.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE+TAO-6.4.0.tar.bz2"
  sha256 "8177d4f16bf013f7a003a7d1f83de9fda646406754c1f4cc0b0964a4b839eb0f"

  bottle do
    cellar :any
    sha256 "0b53c1e14820be00af7115e9afefa09a380803589597038d962bb8ab16b79331" => :el_capitan
    sha256 "d3e7e45197f7d7643d675ff84057df769947f6c0a9185388d23b2a28375760f0" => :yosemite
    sha256 "72f21357797c350fe547a7978f402e564cf328c3662a0e321d1ec293f4899139" => :mavericks
  end

  def install
    # Figure out the names of the header and makefile for this version
    # of OSX and link those files to the standard names.
    name = MacOS.cat.to_s.delete "_"
    ln_sf "config-macosx-#{name}.h", "ace/config.h"
    ln_sf "platform_macosx_#{name}.GNU", "include/makeinclude/platform_macros.GNU"

    # Set up the environment the way TAO expects during build.
    ENV["ACE_ROOT"] = buildpath
    ENV["TAO_ROOT"] = "#{buildpath}/TAO"
    ENV["DYLD_LIBRARY_PATH"] = "#{buildpath}/lib"

    # Done! We go ahead and build.
    system "make", "-C", "ace", "-f", "GNUmakefile",
                   "INSTALL_PREFIX=#{prefix}",
                   "LDFLAGS=",
                   "DESTDIR=",
                   "INST_DIR=/tao",
                   "debug=0",
                   "shared_libs=1",
                   "static_libs=0",
                   "install"

    system "make", "-C", "ace", "apps", "gperf", "src",  "-f", "GNUmakefile.gperf",
                   "INSTALL_PREFIX=#{prefix}",
                   "LDFLAGS=",
                   "DESTDIR=",
                   "INST_DIR=/tao",
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

  end

  test do
  end
end
