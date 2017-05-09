class Steem < Formula
  desc "Proof of Work blockchain with an unproven consensus algorithm."
  homepage "https://steemit.com/"
  url "https://github.com/steemit/steem.git",
      :tag => "v0.13.0",
      :revision => "045c2a340d254d11dfcd22e1253646132465f9b7"

  depends_on :macos => [:yosemite, :el_capitan, :sierra]

  depends_on "cmake" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :python3 => :build
  depends_on "doxygen" => :build
  depends_on "berkeley-db" => :optional
  depends_on "gperftools" => :optional
  depends_on "icu4c"
  depends_on "boost160"
  depends_on "openssl"
  depends_on "readline"

  def install
    cmake_args = %W[
      CMakeLists.txt
      -DCMAKE_BUILD_TYPE=Release
      -DLOW_MEMORY_NODE=OFF
      -DENABLE_CONTENT_PATCHING=ON
      -DBOOST_ROOT=/usr/local/opt/boost160
    ]

    system "cmake", *(cmake_args + std_cmake_args)
    system "make", "install"
  end

  test do
    system "#{bin}/steemd", "-h"
  end
end
