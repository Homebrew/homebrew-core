class Yyjson < Formula
  desc "High performance JSON library written in ANSI C"
  homepage "https://github.com/ibireme/yyjson"
  url "https://github.com/ibireme/yyjson/archive/refs/tags/0.12.0.tar.gz"
  sha256 "b16246f617b2a136c78d73e5e2647c6f1de1313e46678062985bdcf1f40bb75d"
  license "MIT"
  head "https://github.com/ibireme/yyjson.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d416441b16b8711e09fc69b58bd20996d5e89c1d79bfeee6a38056b3fe860d84"
    sha256 cellar: :any,                 arm64_sequoia: "10404c0fedca884468cb47b57e185ee54e21f0f9010a18047123f717970dc28a"
    sha256 cellar: :any,                 arm64_sonoma:  "0a16ceb0708e9ca44bb42c7d7dd5190984d5b83b7c7627148ecb607089e695e4"
    sha256 cellar: :any,                 arm64_ventura: "cbd69152fd22ccd9b9de97251c1c2f7243283f7cef0174f51a26eec878f5e687"
    sha256 cellar: :any,                 sonoma:        "474db0266ef4054ad4cfe009ecc297a36085383f27b64099f7f98f3eca54b1be"
    sha256 cellar: :any,                 ventura:       "27ed6f49a4b4ec723e016576595bc05b09023ea1a2d431ce99d96b0fcf8fa2a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e8f897689182345192194e1ee03c735d41694c43183814123d7c25f6190d084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "add1ef7d14987dd39a1a1404ed435db18a4d12e56fe9e09772e857623749f630"
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
