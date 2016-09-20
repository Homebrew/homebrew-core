class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb2017_20160722oss_src.tgz"
  version "4.4-20160722"
  sha256 "fd5fb4c4e0bf6025eb45d12bd7a474821c8e1b45dbf39fe50a256aa4c7ae190d"

  bottle do
    cellar :any
    rebuild 2
    sha256 "36b58a15f159a9e80b3d681ddb0861db319cc7f64644db3102d54778ffe2878b" => :sierra
    sha256 "fb0e2ad65a78c7402bd45c932d9c05a2fdebc62ad19d09166bec235909a1f0a6" => :el_capitan
    sha256 "68c2752f7bdb5ea84bf205a3ed73fd7ccb3fc4473bb56a6366084c9ff6291075" => :yosemite
  end

  option :cxx11

  # requires malloc features first introduced in Lion
  # https://github.com/Homebrew/homebrew/issues/32274
  depends_on :macos => :lion
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "swig" => :build

  def install
    # Intel sets varying O levels on each compile command.
    ENV.no_optimization

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
