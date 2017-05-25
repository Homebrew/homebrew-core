class Rxcpp < Formula
  desc "Reactive Extensions for C++"
  homepage "https://rxcpp.codeplex.com/"
  url "https://github.com/Reactive-Extensions/RxCpp.git",
      :tag => "v3.0.0",
      :revision => "8290f92f744f807e83b1bfe9e8c0ffd162140ec8"
  head "https://github.com/Reactive-Extensions/RxCpp.git"

  bottle :unneeded

  option "with-test", "Build and run the test suite"

  depends_on "cmake" => :build if build.with? "test"

  def install
    if build.with? "test"
      ENV.cxx11
      mkdir "build" do
        system "cmake", "..", *std_cmake_args
        system "make"
        system "./build/test/rxcpp_test_all"
      end
    end
    include.install "Rx/v2/src/rxcpp"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
        #include <rxcpp/rx-test.hpp>
        namespace rx=rxcpp;
        namespace rxu=rxcpp::util;
        namespace rxs=rxcpp::sources;
        namespace rxsc=rxcpp::schedulers;

        int main(int argc, char** argv) {
            auto sc = rxsc::make_test();
            auto w = sc.create_worker();
            const rxsc::test::messages<int> on;

            auto res = w.start(
                []() {
                    return rx::observable<>::empty<int>().as_dynamic();
                }
            );

            auto required = rxu::to_vector({
                on.completed(200)
            });
            auto actual = res.get_observer().messages();

            return 0;
        }
    EOS
    flags = ["-std=c++11", "-stdlib=libc++", "-I#{include}"] + ENV.cflags.to_s.split
    system ENV.cxx, "-o", "test", "test.cpp", *flags
    system "./test"
  end
end
