class Soci < Formula
  desc "Database access library for C++"
  homepage "http://soci.sourceforge.net/"
  url "https://download.sourceforge.net/project/soci/soci/soci-3.2.2/soci-3.2.2.zip"
  sha256 "e3ad3ea0ef37eab0ae9e6459d2cdd099b1fa1165b663c349e1200356cf4e9c91"

  bottle do
    sha256 "9932dbe8cf88a7951ee909ef02d348fd45296e79cd7b1c8beeba6e5375578e01" => :sierra
    sha256 "36f059c90784c6d4ebe3bcf9f83babddb2bbfef0b108eda04deb4c98e4e5b119" => :el_capitan
    sha256 "a442c3d3c94c6132bd3e03a2f4b7dc34c1163b6befd807494dbc90049d7a1d82" => :yosemite
    sha256 "7ea7c9074d708f276244e9b6a5251406a2b1fc7b6d57d0974b98e87df21f24cd" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "boost" => [:build, :optional]
  depends_on "sqlite" if MacOS.version <= :snow_leopard

  option "with-oracle", "Enable Oracle support."
  option "with-boost", "Enable boost support."
  option "with-mysql", "Enable MySQL support."
  option "with-odbc", "Enable ODBC support."
  option "with-pg", "Enable PostgreSQL support."

  def translate(a)
    a == "pg" ? "postgresql" : a
  end

  fails_with :clang do
    build 421
    cause "Template oddities"
  end

  def install
    args = std_cmake_args + %w[.. -DWITH_SQLITE3:BOOL=ON]

    %w[boost mysql oracle odbc pg].each do |a|
      bool = build.with?(a) ? "ON" : "OFF"
      args << "-DWITH_#{translate(a).upcase}:BOOL=#{bool}"
    end

    mkdir "build" do
      system "cmake", *args
      system "make", "install"
    end
  end
end
