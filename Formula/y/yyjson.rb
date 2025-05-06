class Yyjson < Formula
  desc "High performance JSON library written in ANSI C"
  homepage "https://github.com/ibireme/yyjson"
  url "https://github.com/ibireme/yyjson/archive/refs/tags/0.11.0.tar.gz"
  sha256 "0cc453318ff299ab61ec233b5b92dd474dee39028ad77904b19a45a79651574e"
  license "MIT"
  head "https://github.com/ibireme/yyjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "68d35b2ca7d96abf364d85272a5c72745bdfcc82e9da37b2af786c1944b0316d"
    sha256 cellar: :any,                 arm64_sonoma:  "7491ad6b1c88e3db721c1f048ab42c8537b80c67ed938dfcd3a71b1ab24f4b7c"
    sha256 cellar: :any,                 arm64_ventura: "100373898fcf7f9e61ca575e3b903c1cf6f9266636bb8d27f8fb696158b8a04f"
    sha256 cellar: :any,                 sonoma:        "10829f95adddff68018a86f3aa357d7f98851c61435e56c147b742ba784032be"
    sha256 cellar: :any,                 ventura:       "5b9f3ef229e75245654a76c3d17c2c35bf61d1fe1fd89469cd08ebb9e24edd0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f60959122ff0b42dc3e10bd2f948fbc226c4b8da575683154eb367a4a7eb2b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e29aa5d24a555b58224b3f416287dc121132dbfa04412af8c1c2412494ae2ef"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <yyjson.h>

      int main() {
        const char *json = "{\\"name\\":\\"John\\",\\"star\\":4,\\"hits\\":[2,2,1,3]}";
        yyjson_doc *doc = yyjson_read(json, strlen(json), 0);
        yyjson_val *root = yyjson_doc_get_root(doc);

        yyjson_val *name = yyjson_obj_get(root, "name");
        printf("name: %s\\n", yyjson_get_str(name));
        printf("name length: %d\\n", (int)yyjson_get_len(name));

        yyjson_val *star = yyjson_obj_get(root, "star");
        printf("star: %d\\n", (int)yyjson_get_int(star));

        yyjson_val *hits = yyjson_obj_get(root, "hits");
        size_t idx, max;
        yyjson_val *hit;
        yyjson_arr_foreach(hits, idx, max, hit) {
            printf("hit[%d]: %d\\n", (int)idx, (int)yyjson_get_int(hit));
        }

        yyjson_doc_free(doc);
      }
    C

    expected_output = <<~EOS
      name: John
      name length: 4
      star: 4
      hit[0]: 2
      hit[1]: 2
      hit[2]: 1
      hit[3]: 3
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lyyjson", "-o", "test"
    assert_equal expected_output, shell_output(testpath/"test")
  end
end
