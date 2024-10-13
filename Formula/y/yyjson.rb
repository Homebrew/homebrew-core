class Yyjson < Formula
  desc "High performance JSON library written in ANSI C"
  homepage "https://github.com/ibireme/yyjson"
  url "https://github.com/ibireme/yyjson/archive/refs/tags/0.10.0.tar.gz"
  sha256 "0d901cb2c45c5586e3f3a4245e58c2252d6b24bf4b402723f6179523d389b165"
  license "MIT"
  head "https://github.com/ibireme/yyjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e65d628c23f52ed3078fa3078cb66b8db8e11f4a890598794973fa41b8c17a79"
    sha256 cellar: :any,                 arm64_sonoma:   "9ab9c2ecf8f02f0c781afa350b60bfedc128100a6fc33a39f8fda630797c10b1"
    sha256 cellar: :any,                 arm64_ventura:  "8085a2cccc46355a7cd7de87f15b65705e32bc7095edac87a55d0544befce88a"
    sha256 cellar: :any,                 arm64_monterey: "d83d78ab70d9243f1b1efb995f933de45b24b78bbc304f078ff5b937ff105d00"
    sha256 cellar: :any,                 sonoma:         "04f0f2b5ec7c3940b6fefe7dfc3a8478b370bae125c7933565584c73f9a28480"
    sha256 cellar: :any,                 ventura:        "b32d5220a84af677e9ba28e60c90f7c5797a8cf97020a33f16a3bd931bb538d9"
    sha256 cellar: :any,                 monterey:       "c73550bf23abcf2cd1ab01f1ee704cd933694785cb574115a6b347fc72aa250a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dec9417966cf48f6459914f0a32d46b608a0fe8068590b2643d1f08e8accf24"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS

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
