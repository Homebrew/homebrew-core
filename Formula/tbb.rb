class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://github.com/01org/tbb/archive/2019_U4.tar.gz"
  version "2019_U4"
  sha256 "342a0a2cd583879850658284b86e9351ea019b4f3fcd731f4c18456f0ce9f900"

  bottle do
    cellar :any
    sha256 "3b5ac43b2280ebbebc39541a95a63e287b08eceb8ba75912cd8b89f731ffe663" => :mojave
    sha256 "fc57daae5222af5ba8178f810113ac37066b40d268d3e30da78e1aeaa40cfd0f" => :high_sierra
    sha256 "77e4f8db4f7bc6c1327567a8944d5eb3ba5a6503cc1404e65f18284e1f7aabfd" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  # requires malloc features first introduced in Lion
  # https://github.com/Homebrew/homebrew/issues/32274

  depends_on "python"

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
      system "python3", *Language::Python.setup_install_args(prefix)
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
