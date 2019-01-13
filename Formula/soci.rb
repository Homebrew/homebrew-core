class Soci < Formula
  desc "Database access library for C++"
  homepage "https://soci.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/soci/soci/soci-3.2.3/soci-3.2.3.zip"
  sha256 "ab0f82873b0c5620e0e8eb2ff89abad6517571fd63bae4bdcac64dd767ac9a05"

  bottle do
    sha256 "2e20ceced92132166cffae968a007d5150a6e620c1059e54e82ae0938eaf42ed" => :mojave
    sha256 "b6186caa197c5111b9704cc4b4f133f0f5f656727ed3211c7351e2a97302f10f" => :high_sierra
    sha256 "61ac3ada591371a743198251fa35d70a18cc6018d23e4a36e3ec45aa6ec99db2" => :sierra
    sha256 "4b8d8acc29c2ed8e826be84c9dc777d947033396336885440fb823530460b470" => :el_capitan
    sha256 "b802ee253ceb25ebfd2b5a90ef4dc8b229a90c7b1cae1a33533c9bd2ff9e7d50" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "sqlite" if MacOS.version <= :snow_leopard

  fails_with :clang do
    build 421
    cause "Template oddities"
  end

  def install
    args = std_cmake_args + %w[
      -DWITH_SQLITE3:BOOL=ON
      -DWITH_BOOST:BOOL=OFF
      -DWITH_MYSQL:BOOL=OFF
      -DWITH_ODBC:BOOL=OFF
      -DWITH_ORACLE:BOOL=OFF
      -DWITH_POSTGRESQL:BOOL=OFF
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end
end
