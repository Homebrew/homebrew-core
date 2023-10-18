class Yyjson < Formula
  desc "High performance JSON library written in ANSI C"
  homepage "https://github.com/ibireme/yyjson"
  url "https://github.com/ibireme/yyjson/archive/refs/tags/0.8.0.tar.gz"
  sha256 "b2e39ac4c65f9050820c6779e6f7dd3c0d3fed9c6667f91caec0badbedce00f3"
  license "MIT"
  head "https://github.com/ibireme/yyjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e01eed4e426b1f2263756a7b10f24ee373106c5cc6868cae967e5e4f0994d9e3"
    sha256 cellar: :any,                 arm64_ventura:  "3449c7a7b83124cbd4b1cdbdb42c1a6db8a8828b812324a0103912ce0f562392"
    sha256 cellar: :any,                 arm64_monterey: "9ccea7329ede91039de7149ed5430899abdc2c2a1cd4e19748db266021a49b24"
    sha256 cellar: :any,                 arm64_big_sur:  "a7b669addfdb02dc52c30e59d6c1634b7abec5b5b80c914e790e627150424954"
    sha256 cellar: :any,                 sonoma:         "0cc4fcf63c0cf85caf1dd2ccc2ad021243c862d4b45e75834a2a9edc239c9a95"
    sha256 cellar: :any,                 ventura:        "2dc6a58b5723be0e1b047e1d3d7650a5902d252d593316367c24caf019daf9e2"
    sha256 cellar: :any,                 monterey:       "c5a0af8a58e10bb3e04de71cce8c0c1250b25540055e1eb2061606f324da2e48"
    sha256 cellar: :any,                 big_sur:        "390a4950994bb564c36ebe35d82e38cc825cbcf7a15bead14c2f57e663a97eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61a7083295ed7711ef5c343b895551c3e65cce544b9aca939ad9b13b90ef8917"
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
