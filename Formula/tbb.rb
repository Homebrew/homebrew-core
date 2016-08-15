class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb44_20160526oss_src_0.tgz"
  version "4.4-20160526"
  sha256 "7bafdcc3bca3aa1acc03da4735aefd6a4ddf2eceec983202319d0a911da1f0d1"

  bottle do
    cellar :any
    sha256 "f7d9871559c12347cade68f06a7bb4e3493a843fd916d732fec37af4591577ac" => :el_capitan
    sha256 "60691d873f8357334352bea9b41e93c0dc335c77edd20f755b9f2431e9398a87" => :yosemite
    sha256 "5d51073b2075a47093fca70a17e472fc24836a3cfbabf0f47832c056eb632094" => :mavericks
  end

  option :cxx11

  # requires malloc features first introduced in Lion
  # https://github.com/Homebrew/homebrew/issues/32274
  depends_on :macos => :lion

  def install
    # Intel sets varying O levels on each compile command.
    ENV.no_optimization

    args = %W[tbb_build_prefix=BUILDPREFIX]

    if build.cxx11?
      ENV.cxx11
      args << "cpp0x=1" << "stdlib=libc++"
    end

    system "make", *args
    lib.install Dir["build/BUILDPREFIX_release/*.dylib"]
    include.install "include/tbb"
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
