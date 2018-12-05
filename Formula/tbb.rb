class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://github.com/01org/tbb/archive/2019_U3.tar.gz"
  version "2019_U3"
  sha256 "b2244147bc8159cdd8f06a38afeb42f3237d3fc822555499d7ccfbd4b86f8ece"

  bottle do
    cellar :any
    sha256 "e71225b00b1600e1f5d6fb863b7e4ed2331d2f003966f7360cb2ceb5a5c62ca2" => :mojave
    sha256 "65ab527434fae8d12d0945065ecf41ba37a5a6ebff179adceb60744a524816e1" => :high_sierra
    sha256 "3df673cbf9c0d3b44866b5154e528e8f1a6d941a112bdccaa0b4951ae10077a1" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  # requires malloc features first introduced in Lion
  # https://github.com/Homebrew/homebrew/issues/32274
  depends_on :macos => :lion
  depends_on "python@2"

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
