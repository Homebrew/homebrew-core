class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://github.com/01org/tbb/archive/2018.tar.gz"
  sha256 "94f643f1edfaccb57d64b503c7c96f00dec64e8635c054bbaa33855d72c5822d"

  bottle do
    cellar :any
    sha256 "ad77508883c17c264e3a7b8577efd771828cf02b9d1f8a4ba903b2e26be66422" => :sierra
    sha256 "fa092abc70c26eb61072eba47ea51e4767a2a0c64d450e1e9993dc3addb87c5f" => :el_capitan
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
