class Tmx < Formula
  desc "Portable C library to load tiled maps in your games"
  homepage "https://github.com/baylej/tmx"
  url "https://github.com/baylej/tmx/archive/tmx_1.4.0.tar.gz"
  sha256 "5ab52e72976141260edd1b15ea34e1626c0f4ba9b8d2afe7f4d68b51fc9fedf7"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "4a02eaad5feda5bd83ddbc7292dab864a9e031861e739dd12270daa10ac762da" => :big_sur
    sha256 "3e571d91e3c0e20a9e6a5cbf75d097b04ff7045e00b7beb092d2d9bf09e5cc36" => :arm64_big_sur
    sha256 "0263118ee359ad7dc4d1ff0eb9ab68de5903b38d9ab337bb0dda83ae2fc04b55" => :catalina
    sha256 "badbdbca1c082cd0d1229f0d4d3e200051d90a9cd95a99db4a35b370858f1070" => :mojave
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
