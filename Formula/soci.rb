class Soci < Formula
  desc "Database access library for C++"
  homepage "https://soci.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/soci/soci/soci-3.2.3/soci-3.2.3.zip"
  sha256 "ab0f82873b0c5620e0e8eb2ff89abad6517571fd63bae4bdcac64dd767ac9a05"

  bottle do
    rebuild 1
    sha256 "0fd00b5a595f94e6e62cb7f6976816bca6a747ed3a98b0327f5961548e2606ef" => :catalina
    sha256 "e0898c45669d19255465f990c9ac4ea6f6b42c4c6de7688d5ca137f77080bc55" => :mojave
    sha256 "bf08b482820dd4ce1613b662d573caeeb0e9e78d379d7f21dee9118833867e65" => :high_sierra
    sha256 "db0a84d0ac41fb65d0bdea2eccc652754bdacca85b8659aec879d85101f2d276" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "sqlite"

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
