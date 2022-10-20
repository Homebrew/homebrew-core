class Tmx < Formula
  desc "Portable C library to load tiled maps in your games"
  homepage "https://github.com/baylej/tmx"
  url "https://github.com/baylej/tmx/archive/tmx_1.4.0.tar.gz"
  sha256 "5ab52e72976141260edd1b15ea34e1626c0f4ba9b8d2afe7f4d68b51fc9fedf7"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1741909448819ba29272e002c9d25fdb8cc315e0ea70991799e2bbfa4bcdb88f"
    sha256 cellar: :any,                 arm64_big_sur:  "770cdb601ea6b496a29832960cb5fd79626a99f55f01c635985aa921f3e5f31d"
    sha256 cellar: :any,                 monterey:       "fd62803bd77e4f17e11137d591ee0f916eea138b4e9a076355fea04f5a01d67c"
    sha256 cellar: :any,                 big_sur:        "91e9846b6d59e0694918753e357736c229c2a70d8021fdbaa2eb506e5be746c2"
    sha256 cellar: :any,                 catalina:       "1013715fdb263f6d6985c9145a5dbc05d2e41ba6c4aa28af766f0bc82a87f2c5"
    sha256 cellar: :any,                 mojave:         "060eab2a5090afed9dfbf6ca716a2867b956be2222e6a623a5b98774bf06ef6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ab5a06f59f128524607cfc604d1f7a5b40875572bd4516524fd61bb5db4ba13"
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
