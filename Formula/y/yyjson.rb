class Yyjson < Formula
  desc "High performance JSON library written in ANSI C"
  homepage "https://github.com/ibireme/yyjson"
  url "https://github.com/ibireme/yyjson/archive/refs/tags/0.7.0.tar.gz"
  sha256 "9b91ee48ac1fe5939f747d49f123d9a522b5f4e1e46165c1871936d583628a06"
  license "MIT"
  head "https://github.com/ibireme/yyjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b6bac0295145a59d5f71c343db6ac6d1e948df09c6d22bc5bc78ee9fee3808db"
    sha256 cellar: :any,                 arm64_monterey: "1c1a55c76ee36ae972aec250fb53cce4c0ee20b6a059fe0da32556fa01c8caa9"
    sha256 cellar: :any,                 arm64_big_sur:  "bb39c4690b578fb5a7d1d23f4e7fc486d711dcca0d468fc81db3e8ca9c3c7505"
    sha256 cellar: :any,                 ventura:        "4dae75c464e8b0f897de3565b5fd645ac2eaf8bfd8f56b2c435f1ad1772267fa"
    sha256 cellar: :any,                 monterey:       "f101391775b924424c2b340d8b80dc600ef268711ab8042b973008d81b80fc0b"
    sha256 cellar: :any,                 big_sur:        "5df824a5bb3b260dc471c9373d525711d1006ff234f719d3e87bf4c10e80b01b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7232926fd910314cd7c9fe6a6426309064d00f3e43025a8a5dd9ec56ddfe0b25"
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
