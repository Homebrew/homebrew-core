class Tmx < Formula
  desc "Portable C library to load tiled maps in your games"
  homepage "https://libtmx.readthedocs.io/en/latest/"
  url "https://github.com/baylej/tmx/archive/refs/tags/tmx_1.10.0.tar.gz"
  sha256 "8ee42d1728c567d6047a58b2624c39c8844aaf675c470f9f284c4ed17e94188f"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "59fd63f6b2a662a31a2fe3236c1de7ba84f6e77a2841aeff3b88887529c6ee0a"
    sha256 cellar: :any,                 arm64_sequoia: "02fab021d2ec2f4b39dbf13c2b9413b8fb83dff9a6ef545c9cdd33a4b836f0c1"
    sha256 cellar: :any,                 arm64_sonoma:  "113721aaa83e493f710b297e0d2380184ec6f833d60e00e29ff791df81678de4"
    sha256 cellar: :any,                 sonoma:        "a73375f15292e0db390e8558cdbee774ef6de08263b01d0559e7fadd20c46ca7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09de5000a939def5e7509f5f5b1336ed49e1fe1971ee0edde526cc1d4eddf854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc85e452c93cdf87fc8433f8ec600978b8083dc7b1d56797c6596270a48b62ae"
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
