class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://github.com/01org/tbb/archive/2017_U6.tar.gz"
  version "2017_U6"
  sha256 "1f7df7af6045179a45eba9b5dfde74d185ee7f573328f103c137696f81e4ae5a"

  bottle do
    cellar :any
    sha256 "5611665aa428d6bdba242090a5a9ca721b72346bfcc49a1e6bdc05c709a9f8ce" => :sierra
    sha256 "a29b8a89c67897b03e07e26e854b45c9b3ed191ad555da8678d389bfc924ae26" => :el_capitan
    sha256 "cec75ccdcde698d7ca0819532b31a3c6bf33d931d0e623dbc4d323ded63365c9" => :yosemite
  end

  option :cxx11

  # requires malloc features first introduced in Lion
  # https://github.com/Homebrew/homebrew/issues/32274
  depends_on :macos => :lion
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "swig" => :build

  def install
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
