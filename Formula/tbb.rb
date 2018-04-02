class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://github.com/01org/tbb/archive/2018_U3.tar.gz"
  version "2018_U3"
  sha256 "23793c8645480148e9559df96b386b780f92194c80120acce79fcdaae0d81f45"
  revision 1

  bottle do
    sha256 "2d06624e2fc0789319e8f23df892c0b808fd2a45fb30be565a424e29279ee81c" => :high_sierra
    sha256 "e0fe9ea8bb941e2cfd82976fd1d99e60dbe2566c693288952d423d0576e5cd42" => :sierra
    sha256 "83425ac57613f786a2b2d506ce69258501a771a58da1cc13727dd9209d492432" => :el_capitan
  end

  # requires malloc features first introduced in Lion
  # https://github.com/Homebrew/homebrew/issues/32274
  depends_on :macos => :lion
  depends_on "python@2" if MacOS.version <= :snow_leopard
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
