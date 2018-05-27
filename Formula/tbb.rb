class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://github.com/01org/tbb/archive/2018_U3.tar.gz"
  version "2018_U3"
  sha256 "23793c8645480148e9559df96b386b780f92194c80120acce79fcdaae0d81f45"
  revision 2

  bottle do
    rebuild 1
    sha256 "4f0885ab822d155ce1efa2bb97d806def0d673a3722f78b42c43dbdd1c0f42d4" => :high_sierra
    sha256 "f09600c4a04ddd3875d43efa1a9f73dff2a63aa5a881f7f08dc9012a73d2aca9" => :sierra
    sha256 "fbfa4708d7da9406fb66ae9e59b26075ca4a747dc664cc0f057aeb2f7a9d6d8d" => :el_capitan
  end

  # requires malloc features first introduced in Lion
  # https://github.com/Homebrew/homebrew/issues/32274
  depends_on :macos => :lion
  depends_on "python@2"
  depends_on "swig" => :build
  depends_on "cmake" => :build

  def install
    compiler = (ENV.compiler == :clang) ? "clang" : "gcc"
    system "make", "tbb_build_prefix=BUILDPREFIX", "compiler=#{compiler}"
    lib.install Dir["build/BUILDPREFIX_release/*.dylib"]

    # Build and install static libraries
    system "make", "tbb_build_prefix=BUILDPREFIX", "compiler=#{compiler}",
                   "extra_inc=big_iron.inc"
    lib.install Dir["build/BUILDPREFIX_release/*.a"]
    include.install "include/tbb"

    cd "python" do
      ENV["TBBROOT"] = prefix
      system "python", *Language::Python.setup_install_args(prefix)
    end

    system "cmake", "-DTBB_ROOT=#{prefix}",
                    "-DTBB_OS=Darwin",
                    "-DSAVE_TO=lib/cmake/TBB",
                    "-P", "cmake/tbb_config_generator.cmake"

    (lib/"cmake"/"TBB").install Dir["lib/cmake/TBB/*.cmake"]
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
