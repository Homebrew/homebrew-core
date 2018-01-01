class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://github.com/01org/tbb/archive/2018_U2.tar.gz"
  version "2018_U2"
  sha256 "78bb9bae474736d213342f01fe1a6d00c6939d5c75b367e2e43e7bf29a6d8eca"

  bottle do
    sha256 "ac31698064d5177e6d72f8f57a8b359b523b4f1cc824d16bdc1ef9c6ed654361" => :high_sierra
    sha256 "1f200261fcf061bb022503be5cf5e6a69b5c359c64ea475a0ff7698035909d9e" => :sierra
    sha256 "1b3f01c4baee65f4c321023646cf03ef5cae1aa7dd2ba8b1bfa069bda19c4777" => :el_capitan
  end

  # requires malloc features first introduced in Lion
  # https://github.com/Homebrew/homebrew/issues/32274
  depends_on :macos => :lion
  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "swig" => :build

  def install
    compiler = (ENV.compiler == :clang) ? "clang" : "gcc"
    args = %W[tbb_build_prefix=BUILDPREFIX compiler=#{compiler}]

    system "make", *args
    lib.install Dir["build/BUILDPREFIX_release/*.dylib"]
    include.install "include/tbb"

    cd "python" do
      ENV["TBBROOT"] = prefix
      system "python", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
