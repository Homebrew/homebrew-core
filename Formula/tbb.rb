class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb44_20160526oss_src_0.tgz"
  version "4.4-20160526"
  sha256 "7bafdcc3bca3aa1acc03da4735aefd6a4ddf2eceec983202319d0a911da1f0d1"

  bottle do
    cellar :any
    rebuild 1
    sha256 "db0eab0393252553a2d0d409008281c1c71bd5e3b84d7d11f61c360f51704988" => :sierra
    sha256 "e005a2ed49deb9f4594cf99e0294f964da1cc4af14e4035d04b499c55a8ad628" => :el_capitan
    sha256 "9b956c24106f29433ff5b3e8ea3f94d2e1b5b800a1eb32d697fdf60e8978768b" => :yosemite
    sha256 "0dd424959052ce80bf4a5f6a37254f15009ca9d450d8c799145fff55efc5268d" => :mavericks
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
