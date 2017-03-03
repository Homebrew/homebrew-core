class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://github.com/01org/tbb/archive/2017_U5.tar.gz"
  version "2017_U5"
  sha256 "780baf0ad520f23b54dd20dc97bf5aae4bc562019e0a70f53bfc4c1afec6e545"

  bottle do
    cellar :any
    sha256 "d579543e2e91649dbc74a7bc594373d4889790e847fec2c5c6d513e631407d17" => :sierra
    sha256 "7ade84a997d4f66b6f1d143d03b9d380ec546e7126ef19b37b50a10dc761a3cc" => :el_capitan
    sha256 "8e9d170d3c567632a7426d74b14630b72b44c2b49d3d7b26ca3484f48eaddaa9" => :yosemite
  end

  option :cxx11

  # requires malloc features first introduced in Lion
  # https://github.com/Homebrew/homebrew/issues/32274
  depends_on :macos => :lion
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "swig" => :build

  def install
    compiler = ENV.compiler == :clang ? "clang" : "gcc"
    args = %W[tbb_build_prefix=BUILDPREFIX compiler=#{compiler}]

    if build.cxx11?
      ENV.cxx11
      args << "cpp0x=1" << "stdlib=libc++"
    end

    system "make", *args
    lib.install Dir["build/BUILDPREFIX_release/*.dylib"]
    include.install "include/tbb"

    cd "python" do
      ENV["TBBROOT"] = prefix
      system "python", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <tbb/task_scheduler_init.h>
      #include <iostream>

      int main()
      {
        std::cout << tbb::task_scheduler_init::default_num_threads();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-ltbb", "-o", "test"
    system "./test"
  end
end
