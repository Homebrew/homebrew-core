class TbbAT2020 < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://github.com/oneapi-src/oneTBB"
  url "https://github.com/intel/tbb/archive/v2020.3.tar.gz"
  version "2020_U3"
  sha256 "ebc4f6aa47972daed1f7bf71d100ae5bf6931c2e3144cf299c8cc7d041dca2f3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4952c34677c9f46439af82b8ffb45f1b880038eae7b4e4b9262ed81694d103d2"
    sha256 cellar: :any,                 arm64_big_sur:  "60d6f53048879cec2af79648d56cc206c7bdd6044259244e8523ab2f49c8152b"
    sha256 cellar: :any,                 monterey:       "6c2dacae52a54b7a9a8371cf0f9e438be2a6f7e527f4b7c8e757a2aa3f9062dd"
    sha256 cellar: :any,                 big_sur:        "596f3f92c1765f24b9dc9cd866e8068c505428c9dcb9941df7b5f0ea4e10cde9"
    sha256 cellar: :any,                 catalina:       "65adefc9242c9bcadfa22eeb8fbe67c8ac750d59107b7ea69da3715d1c2cbd78"
    sha256 cellar: :any,                 mojave:         "7016ea351af4cab641ab86faa3f0cd50a3cc9f262ea4afdcc70b058e3d467e99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6349e928b34634e00408e762ab7fbe6f77da5586c61251080a677e7e0209d766"
  end

  keg_only :versioned_formula

  deprecate! date: "2020-04-02", because: :unsupported

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "python@3.9"

  # Remove when upstream fix is released
  # https://github.com/oneapi-src/oneTBB/pull/258
  patch do
    url "https://github.com/oneapi-src/oneTBB/commit/86f6dcdc17a8f5ef2382faaef860cfa5243984fe.patch?full_index=1"
    sha256 "d62cb666de4010998c339cde6f41c7623a07e9fc69e498f2e149821c0c2c6dd0"
  end

  def install
    compiler = (ENV.compiler == :clang) ? "clang" : "gcc"
    system "make", "tbb_build_prefix=BUILDPREFIX", "compiler=#{compiler}"
    lib.install Dir["build/BUILDPREFIX_release/#{shared_library("*")}"]

    # Build and install static libraries
    system "make", "tbb_build_prefix=BUILDPREFIX", "compiler=#{compiler}",
                   "extra_inc=big_iron.inc"
    lib.install Dir["build/BUILDPREFIX_release/*.a"]
    include.install "include/tbb"

    cd "python" do
      ENV["TBBROOT"] = prefix
      if OS.linux?
        system "make", "-C", "rml", "compiler=#{compiler}", "CPATH=#{include}"
        lib.install Dir["rml/libirml.so*"]
      end
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
    end

    system "cmake", *std_cmake_args,
                    "-DINSTALL_DIR=lib/cmake/TBB",
                    "-DSYSTEM_NAME=#{OS.kernel_name}",
                    "-DTBB_VERSION_FILE=#{include}/tbb/tbb_stddef.h",
                    "-P", "cmake/tbb_config_installer.cmake"

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
    system ENV.cxx, "test.cpp", "-L#{lib}", "-I#{include}", "-ltbb", "-o", "test"
    system "./test"
  end
end
