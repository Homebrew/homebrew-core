class Tmx < Formula
  desc "Portable C library to load tiled maps in your games"
  homepage "https://libtmx.readthedocs.io/en/latest/"
  url "https://github.com/baylej/tmx/archive/refs/tags/tmx_1.10.1.tar.gz"
  sha256 "05a141abb5e1a6464242a888041bc81a8e1a032baf0f30a00e350f441f162c08"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "33622bf420772d45c0204fb92ec1590b87d3369a58f763a6e114741485a542e7"
    sha256 cellar: :any,                 arm64_sequoia: "e6dc29611a21a58d607b8f909c28da5fe03747e11b3b5deb6fd1772a02b1808a"
    sha256 cellar: :any,                 arm64_sonoma:  "9d60c6c581f835bf59b0bc732cd0c8137e11c5c4e4ae2a52556dd85e17122ccd"
    sha256 cellar: :any,                 sonoma:        "b02700086955197cb6eaf260927995d83661e158785b5f187ed1160b25f7ba66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee63fd16c842235aea7f716fee0baccb34a34e6bc1902c0ba2902bc1c8cbea29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e57cc9a54b874ed75a89a4b559c02214b8535c52f44631d09a776c03a17f2a7"
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
