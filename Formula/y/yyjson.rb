class Yyjson < Formula
  desc "High performance JSON library written in ANSI C"
  homepage "https://github.com/ibireme/yyjson"
  url "https://github.com/ibireme/yyjson/archive/refs/tags/0.11.1.tar.gz"
  sha256 "610a38a5e59192063f5f581ce0c3c1869971c458ea11b58dfe00d1c8269e255d"
  license "MIT"
  head "https://github.com/ibireme/yyjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "be33f4c52f3a3ca9e3bec1672536ba743a3b1635d42179ab9173b945b9d4a6c4"
    sha256 cellar: :any,                 arm64_sonoma:  "6ff845ea14ced22f1f3585c87f32dcbbfdcc43da79b047c2b7e03eb403edabb7"
    sha256 cellar: :any,                 arm64_ventura: "a27c8654370e7639f4358137195d56e38bd8b99f32eaa9d3bbf530b449116b5c"
    sha256 cellar: :any,                 sonoma:        "d0c7ae8b75e9aaca959798ab7e39093f7afcd76584bcc46edb8c74425af4c255"
    sha256 cellar: :any,                 ventura:       "4f6b77f8784820f415fcc8ce870181dccae2a7c6b322d46e781d3ebdedda20e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91527b3761383f2f462b56111bff0add9a29daa372db3a81a69ca6e2102874e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cc670a7221472e4bc8893a82e54b0d7c7a777486db590d1b068714b7e107570"
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
