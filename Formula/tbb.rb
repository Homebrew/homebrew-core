class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://github.com/01org/tbb/archive/2017_U6.tar.gz"
  version "2017_U6"
  sha256 "1f7df7af6045179a45eba9b5dfde74d185ee7f573328f103c137696f81e4ae5a"

  bottle do
    cellar :any
    sha256 "855778d984dcc4a010cda6314e866ac2e85d33992d0f8e616c43c706b5016b3c" => :sierra
    sha256 "86c0a9cb131520adbb731bfcbfc70f5f0c1572fe1adfcbb9fb04e372cf17860f" => :el_capitan
    sha256 "0c0f736453f18bdbf373fde5a6f2823036067416fe1e3bf86e6c858895c7b074" => :yosemite
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
