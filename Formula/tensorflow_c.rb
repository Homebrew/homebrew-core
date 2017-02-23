class TensorflowC < Formula
  desc "C interface for Google's OS library for Machine Intelligence"
  homepage "https://www.tensorflow.org/"
  url "https://github.com/tensorflow/tensorflow", :using => :git,
    :tag => "v1.0.0", :revision => "07bb8ea2379bd459832b23951fb20ec47f3fdbd4"

  depends_on "bazel" => :build
  depends_on "pkg-config" => :run

  def install
    system 'echo "\n\n\n\n\n\n\n\n\n" | ./configure'
    system "bazel", "build", "--compilation_mode=opt", "--copt=-march=native", "tensorflow:libtensorflow_c.so"
    lib.install "bazel-bin/tensorflow/libtensorflow_c.so"
    cp "tensorflow/c/c_api.h", "tensorflow_c_api.h"
    include.install "tensorflow_c_api.h"
    pc = <<-EOF.gsub(/^\s+/, "")
      Name: tensorflow_c
      Description: Tensorflow c lib
      Version: #{version}
      Libs: -L#{lib} -ltensorflow_c
      Cflags: -I#{include}
    EOF
    mkdir_p(lib/"pkgconfig")
    File.open(lib/"pkgconfig/tensorflow_c.pc", "w") { |f| f.write(pc) }
  end

  test do
    # test a call on TF_Version(), checking .h, .so, pkg-config setup.
    File.open("test.c", "w") do |f|
      f.write(<<-EOF.gsub(/^\s+/, ""))
      #include <stdio.h>
      #include <tensorflow_c_api.h>
      int main() {
        printf("%s\\n", TF_Version());
      }
      EOF
    end
    system "sh", "-c", "gcc `pkg-config --libs --cflags tensorflow_c` -o test_tf test.c"
    found_version = `./test_tf`.strip
    assert found_version == version
  end
end
