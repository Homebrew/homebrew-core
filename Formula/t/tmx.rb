class Tmx < Formula
  desc "Portable C library to load tiled maps in your games"
  homepage "https://libtmx.readthedocs.io/en/latest/"
  url "https://github.com/baylej/tmx/archive/refs/tags/tmx_1.10.0.tar.gz"
  sha256 "8ee42d1728c567d6047a58b2624c39c8844aaf675c470f9f284c4ed17e94188f"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "b90d11cd5cb3b8b5d3ed6755386f7a0c61cba35135bf113366b0fe55170c16ed"
    sha256 cellar: :any,                 arm64_sonoma:  "338149122323df8764c414aca5f168221b3b239e988c28a10e4f2a1f08aeb10d"
    sha256 cellar: :any,                 arm64_ventura: "824f876037e825eee41439481c88496183ceeaf3b28b2f6713b76947e000e1d5"
    sha256 cellar: :any,                 sonoma:        "373c7ff58f085aae49d1472d061222aed7d3ed7c67675a982333c77d5bff6ad2"
    sha256 cellar: :any,                 ventura:       "245d68a570c8b1bf021dd5d1fbf40d1b35d0ad3a3fe6839824af29548d8e05b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86b83ccccb9e5ab0ab728bcb5fa4c3ec20f95e2a837d28f0ef20de71cd7f8adf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c43d5b6605675c73193fff26c3f7e8dadbeb89833e9d5dc4a8e6cdbef76526cf"
  end

  depends_on "cmake" => :build

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.tmx").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <map version="1.0" tiledversion="1.0.2" orientation="orthogonal" renderorder="right-down" width="28" height="18" tilewidth="32" tileheight="32">
        <tileset firstgid="1" name="base" tilewidth="32" tileheight="32" spacing="1" tilecount="9" columns="3">
          <image source="numbers.png" width="100" height="100"/>
          <tile id="0"/>
        </tileset>
        <group name="Group">
          <layer name="Layer" width="28" height="18">
          <data encoding="base64" compression="zlib">
          eJy9lN0OgCAIRjX/6v1fuLXZxr7BB9bq4twochioLaVUfqAB11qfyLisYK1nOFsnReztYr8bTsvP9vJ0Yfyq7yno6x/7iuF7mucQRH3WeZYL96y4TZmfVyeueTV4Pq8fXq+YM+Ibk0g9GIv1sX56OTTnGx/mqwTWd80X6T3+ffgPRubNfOjEv0DC3suKTzoHYfV+RtgJlkd7f7fTm4OWi6GdZXNn93H1rqLzBIoiCFE=
          </data>
          </layer>
        </group>
      </map>
    XML
    (testpath/"test.c").write <<~C
      #include <tmx.h>

      int main(void) {
        tmx_map *map = tmx_load("test.tmx");
        tmx_map_free(map);

        tmx_resource_manager *rc_mgr = tmx_make_resource_manager();
        tmx_free_resource_manager(rc_mgr);

        return 0;
      }
    C
    system ENV.cc, "test.c", "#{lib}/#{shared_library("libtmx")}", "-lz", "-lxml2", "-o", "test"
    system "./test"
  end
end
