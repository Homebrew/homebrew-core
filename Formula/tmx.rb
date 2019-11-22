class Tmx < Formula
  desc "Portable C library to load tiled maps in your games"
  homepage "https://github.com/baylej/tmx"
  url "https://github.com/baylej/tmx/archive/tmx_1.0.0.tar.gz"
  sha256 "ba184b722a838a97f514fb7822c1243dbb7be8535b006ef1c5b9f928e295519b"

  bottle do
    cellar :any
    sha256 "846228b02676e378a400f4ca3b4d2ac343faf222c34e654cef66e4e8b3aa8f6c" => :catalina
    sha256 "e84b8ed8574cbd3c67fca475d1172fc7e51a7a6707ea0d5e109f79479b655c27" => :mojave
    sha256 "a0583aec000dcda5738acc799591da7a8495c81bfffa0ee988428191f6840d47" => :high_sierra
    sha256 "591bf5f7712d4406b505c52dc62949b793961a944f0e38b1336a3333d16b0161" => :sierra
  end

  depends_on "cmake" => :build

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
      #include <tsx.h>

      int main(void) {
        tmx_map *map = tmx_load("test.tmx");
        tmx_map_free(map);

        tmx_tileset_manager *ts_mgr = tmx_make_tileset_manager();
        tmx_free_tileset_manager(ts_mgr);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "#{lib}/libtmx.dylib", "-lz", "-lxml2", "-o", "test"
    system "./test"
  end
end
