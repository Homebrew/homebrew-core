class Tmx < Formula
  desc "Portable C library to load tiled maps in your games"
  homepage "https://github.com/baylej/tmx"
  url "https://github.com/baylej/tmx/archive/tmx_1.2.0.tar.gz"
  sha256 "6f9ecb91beba1f73d511937fba3a04306a5af0058a4c2b623ad2219929a4116a"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "6eee68f794cbbb98fe46ec84011d41dc5df720b1ad7068d3903e34de1c2a5e78" => :big_sur
    sha256 "fdd672a6183c12504c5938e3ca0a4bb02028dafd355f37485cd55db9a975d755" => :arm64_big_sur
    sha256 "e751f5545befe34c2e3b531c6c1adb6b256539ed613c1cd4bd3c44be05d5a3a3" => :catalina
    sha256 "20b8c3c1335eb81aace022bbf1086faaaff0aa5aa4e6d6f8858ec62a834e702a" => :mojave
    sha256 "71310fb31b83e16bd21269c8a4c7f396f8e47eda535ede4fc01b61108867c9a6" => :high_sierra
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
