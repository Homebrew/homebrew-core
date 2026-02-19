class Yyjson < Formula
  desc "High performance JSON library written in ANSI C"
  homepage "https://github.com/ibireme/yyjson"
  url "https://github.com/ibireme/yyjson/archive/refs/tags/0.12.0.tar.gz"
  sha256 "b16246f617b2a136c78d73e5e2647c6f1de1313e46678062985bdcf1f40bb75d"
  license "MIT"
  head "https://github.com/ibireme/yyjson.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "bc385fef24ac80239af24728461f03f80ce8107954a4e11149db0c5fbb64acf9"
    sha256 cellar: :any,                 arm64_sequoia: "ac03b7af3eeaad37ff9421f18f09c04e8718e9124bb254442fb783f1e72523ca"
    sha256 cellar: :any,                 arm64_sonoma:  "0a16ceb0708e9ca44bb42c7d7dd5190984d5b83b7c7627148ecb607089e695e4"
    sha256 cellar: :any,                 sonoma:        "474db0266ef4054ad4cfe009ecc297a36085383f27b64099f7f98f3eca54b1be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b4971f272e8ca83e029e7d4ce912261c2e236fea1978732029c770b4454d8fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72d054b4ff70582269754e969cd1a5cf5b670eac46f1bee785855643a8ec7f8d"
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
