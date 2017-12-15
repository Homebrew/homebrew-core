class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://github.com/01org/tbb/archive/2018_U1.tar.gz"
  version "2018_U1"
  sha256 "c6462217d4ecef2b44fce63cfdf31f9db4f6ff493869899d497a5aef68b05fc5"

  bottle do
    cellar :any
    sha256 "d67a5fe90766e6ff5e7d76a79f5d6b321d9ea226614d67d884295bb26ba6d9ae" => :high_sierra
    sha256 "7bb00f4041fb7945c675d58f6d0fa121ac28fb249a211567c0eade71d9e018a0" => :sierra
    sha256 "b9ee2339d50a595189f9b9e9612b0cbf22f84572bf0a2de4081db698a2766de5" => :el_capitan
  end

  # requires malloc features first introduced in Lion
  # https://github.com/Homebrew/homebrew/issues/32274
  depends_on :macos => :lion
  depends_on :python if MacOS.version <= :snow_leopard
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
