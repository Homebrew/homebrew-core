class Teem < Formula
  desc "Libraries for scientific raster data"
  homepage "https://teem.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/teem/teem/1.11.0/teem-1.11.0-src.tar.gz"
  sha256 "a01386021dfa802b3e7b4defced2f3c8235860d500c1fa2f347483775d4c8def"
  head "https://svn.code.sf.net/p/teem/code/teem/trunk"

  bottle do
    sha256 "105f54c1cb830584bcf694756ab18eab2a7d9a67e3226699272c4449cc2f816e" => :catalina
    sha256 "439d02dd7f54d7f307b5984d00448a4e77309660e8f1c52e998ef9ea40fdcaa1" => :mojave
    sha256 "4cb2692b42e79880161879605c3990cd5d0c4fbb171c7ccd003bb9d6bb0fee09" => :high_sierra
    sha256 "31d19cd9e0e4c064fb743c41a286736503e61b1d5e4b81f29140fcebf2cde2c8" => :sierra
    sha256 "5ade8dc18d0c66ac154d802df6c64e88222781b6fc427a841fb1f4047f8c4e49" => :el_capitan
    sha256 "3974a9a565044cb4de798eb1bec2b8980eef03eb6bd7ec6c98cddd606f7c8a29" => :yosemite
    sha256 "c340d18c157b81be663636ff72326ecb946313ea1dfc533a6ba95b9efdb6bf44" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  def install
    # Installs CMake archive files directly into lib, which we discourage.
    # Workaround by adding version to libdir & then symlink into expected structure.
    system "cmake", *std_cmake_args,
                    "-DBUILD_SHARED_LIBS:BOOL=ON",
                    "-DTeem_USE_LIB_INSTALL_SUBDIR:BOOL=ON"
    system "make", "install"

    lib.install_symlink Dir.glob(lib/"Teem-#{version}/*.dylib")
    (lib/"cmake/teem").install_symlink Dir.glob(lib/"Teem-#{version}/*.cmake")
  end

  test do
    system "#{bin}/nrrdSanity"
  end
end
