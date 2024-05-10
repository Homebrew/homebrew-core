class Tmx < Formula
  desc "Portable C library to load tiled maps in your games"
  homepage "https://github.com/baylej/tmx"
  url "https://github.com/baylej/tmx/archive/refs/tags/tmx_1.10.0.tar.gz"
  sha256 "9ca8ffe6acff8a8e8268b1910a0b9f64263cc73758746e6cfe1f2c9e744f4e1f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ffdd9e365993e398ff7bd189f1192e8154fd9a3519698c631214563c6703cbe8"
    sha256 cellar: :any,                 arm64_ventura:  "6e8d898ce87ba2ac78c25c92b6f968f6466a4d33f5b1fc89f377b3408430f36b"
    sha256 cellar: :any,                 arm64_monterey: "094e042ed62d272b8c9c287dd9c9fa86fab00a7214a551269a71209a879c0446"
    sha256 cellar: :any,                 sonoma:         "91be34320e28094fb9073f4e5b54b889688ba61522093ecb36932d31c94e1104"
    sha256 cellar: :any,                 ventura:        "ffcd3179586548d1cdaef53224cc1e18f1cccce51e24da5f72404e6392d52f46"
    sha256 cellar: :any,                 monterey:       "346b4b5f56aa3512beeb3d78d0c82576b7db6823b2a0445d31985133e93851e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0b125b3f78aaebcf8b5b7b9aa3ba1b73838b6cd87aaf4d4d2b88a36b9c16708"
  end

  depends_on "cmake" => :build

  uses_from_macos "libxml2"

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=on", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.tmx").write <<-EOS
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
    EOS
    (testpath/"test.c").write <<-EOS
      #include <tmx.h>

      int main(void) {
        tmx_map *map = tmx_load("test.tmx");
        tmx_map_free(map);

        tmx_resource_manager *rc_mgr = tmx_make_resource_manager();
        tmx_free_resource_manager(rc_mgr);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "#{lib}/#{shared_library("libtmx")}", "-lz", "-lxml2", "-o", "test"
    system "./test"
  end
end
