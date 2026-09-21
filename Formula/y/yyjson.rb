class Yyjson < Formula
  desc "High performance JSON library written in ANSI C"
  homepage "https://ibireme.github.io/yyjson/doc/doxygen/html/"
  url "https://github.com/ibireme/yyjson/archive/refs/tags/0.13.0.tar.gz"
  sha256 "34e0f62a2bc11ab20d601e8ca1cc2b2079503aa45119a19133d89d19b94a0fae"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ibireme/yyjson.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6e0633e376f7139a804923875310ebe936625a6abed59739a231722fdccb8996"
    sha256 cellar: :any, arm64_tahoe:       "653d1e1d0303e93b5471a4a7640f469653b7ca9c642e1568f44fd75bcb207845"
    sha256 cellar: :any, arm64_sequoia:     "f1b9812054f25e115b87e89f26bb43ae44c3c619278583f2e0c652bd8a2e207b"
    sha256 cellar: :any, arm64_sonoma:      "f9b66ab2268ac524c475bf958e3241c3c56a0f7178f9e0abc9edc068dc9280f5"
    sha256 cellar: :any, arm64_linux:       "e563523257fa61cb3d23284e60abbee5ba625e779c0943477b8fa43b023d15c7"
    sha256 cellar: :any, x86_64_linux:      "c7281df3d474b2ec03cfeca7a7721cb14987c7f149a4b33fdd0c2a8f4d2194e4"
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
