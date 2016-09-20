class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb2017_20160722oss_src.tgz"
  version "4.4-20160722"
  sha256 "fd5fb4c4e0bf6025eb45d12bd7a474821c8e1b45dbf39fe50a256aa4c7ae190d"

  bottle do
    cellar :any
    sha256 "949e72923602c999949d3c2a0ca6f9bf3ef2b740c80806f9f669862e6755ec69" => :sierra
    sha256 "b89dc28b6443c6fbf673e164abae48b083eadd9525f6144777f9b94b72ea0e99" => :el_capitan
    sha256 "31e01f0b99a112d99e69d0aa6aa2e0b1f2b261c5d856577ee0f75d7d475bee05" => :yosemite
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
