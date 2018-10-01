class Soci < Formula
  desc "Database access library for C++"
  homepage "https://soci.sourceforge.io/"
  url "https://github.com/SOCI/soci/archive/3.2.3.tar.gz"
  sha256 "1166664d5d7c4552c4c2abf173f98fa4427fbb454930fd04de3a39782553199e"

  bottle do
    sha256 "2e20ceced92132166cffae968a007d5150a6e620c1059e54e82ae0938eaf42ed" => :mojave
    sha256 "b6186caa197c5111b9704cc4b4f133f0f5f656727ed3211c7351e2a97302f10f" => :high_sierra
    sha256 "61ac3ada591371a743198251fa35d70a18cc6018d23e4a36e3ec45aa6ec99db2" => :sierra
    sha256 "4b8d8acc29c2ed8e826be84c9dc777d947033396336885440fb823530460b470" => :el_capitan
    sha256 "b802ee253ceb25ebfd2b5a90ef4dc8b229a90c7b1cae1a33533c9bd2ff9e7d50" => :yosemite
  end

  option "with-oracle", "Enable Oracle support."
  option "with-boost", "Enable boost support."
  option "with-mysql", "Enable MySQL support."
  option "with-odbc", "Enable ODBC support."
  option "with-pg", "Enable PostgreSQL support."

  depends_on "boost" => [:build, :optional]
  depends_on "cmake" => :build
  depends_on "sqlite" if MacOS.version <= :snow_leopard
  depends_on "mysql-client" if build.with?("mysql")

  patch do
    url "https://github.com/SOCI/soci/commit/165737c4be7d6c9acde92610b92e8f42a4cfe933.diff?full_index=1"
    sha256 "29e90baac2d8fa3412485352b0c0ce393cd3a482b951268833ae1dc32336ae0e"
  end

  fails_with :clang do
    build 421
    cause "Template oddities"
  end

  def install
    args = std_cmake_args + %w[../src -DWITH_SQLITE3:BOOL=ON]
    args += %W[-DMYSQL_DIR=#{Formula["mysql-client"].opt_prefix}] if build.with?("mysql")

    %w[boost mysql oracle odbc pg].each do |arg|
      arg_var = (arg == "pg") ? "postgresql" : arg
      bool = build.with?(arg) ? "ON" : "OFF"
      args << "-DWITH_#{arg_var.upcase}:BOOL=#{bool}"
    end

    mkdir "build" do
      system "cmake", *args
      system "make", "install"
    end
  end
end
