class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://github.com/01org/tbb/archive/2018.tar.gz"
  sha256 "94f643f1edfaccb57d64b503c7c96f00dec64e8635c054bbaa33855d72c5822d"

  bottle do
    cellar :any
    sha256 "e2516c576c96bc92b8f8b54727a2df46a82df120a570c8d5f394f30d95a91820" => :high_sierra
    sha256 "72c2ba137d129c98f456513deb3ce3a5aea7750fc8ef1d376ef8a8816c423b45" => :sierra
    sha256 "d96aa9da25acbf1158ec6bfc1db9c490520b50ea143b88054065388e152d3686" => :el_capitan
    sha256 "70c6ad9af59958638e59349e8b2913a9cc1f7f9a918ad7c1f54eda49b1ad757b" => :yosemite
  end

  option :cxx11

  # requires malloc features first introduced in Lion
  # https://github.com/Homebrew/homebrew/issues/32274
  depends_on :macos => :lion
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "swig" => :build

  def install
    compiler = (ENV.compiler == :clang) ? "clang" : "gcc"
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
    system ENV.cxx, "test.cpp", "-L#{lib}", "-ltbb", "-o", "test"
    system "./test"
  end
end
