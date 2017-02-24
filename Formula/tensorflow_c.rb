class TensorflowC < Formula
  desc "C interface for Google's OS library for Machine Intelligence"
  homepage "https://www.tensorflow.org/"
  url "https://github.com/tensorflow/tensorflow.git", :tag => "v1.0.0",
    :revision => "07bb8ea2379bd459832b23951fb20ec47f3fdbd4"

  depends_on "bazel" => :build
  depends_on "pkg-config" => :run

  def install
    ENV["PYTHON_BIN_PATH"]=`which python`.strip
    ENV["CC_OPT_FLAGS"]="-march=native"
    ENV["TF_NEED_JEMALLOC"]="1"
    ENV["TF_NEED_GCP"]="0"
    ENV["TF_NEED_HDFS"]="0"
    ENV["TF_ENABLE_XLA"]="0"
    ENV["USE_DEFAULT_PYTHON_LIB_PATH"]="1"
    ENV["TF_NEED_OPENCL"]="0"
    ENV["TF_NEED_CUDA"]="0"
    system "./configure"

    system "bazel", "build", "--compilation_mode=opt", "--copt=-march=native", "tensorflow:libtensorflow_c.so"
    lib.install "bazel-bin/tensorflow/libtensorflow_c.so"
    include.install "tensorflow/c/c_api.h" => "tensorflow_c_api.h"
    (lib/"pkgconfig/tensorflow_c.pc").write <<-EOS.undent
      Name: tensorflow_c
      Description: Tensorflow c lib
      Version: #{version}
      Libs: -L#{lib} -ltensorflow_c
      Cflags: -I#{include}
    EOS
  end

  test do
    # test a call on TF_Version()
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <tensorflow_c_api.h>
      int main() {
        printf("%s", TF_Version());
      }
    EOS
    system ENV.gcc, "-L#{lib}", "-ltensorflow_c", "-o", "test_tf", "test.c"
    assert_equal version, shell_output("./test_tf")
  end
end
