class Tmx < Formula
  desc "Portable C library to load tiled maps in your games"
  homepage "https://libtmx.readthedocs.io/en/latest/"
  url "https://github.com/baylej/tmx/archive/refs/tags/tmx_1.10.1.tar.gz"
  sha256 "05a141abb5e1a6464242a888041bc81a8e1a032baf0f30a00e350f441f162c08"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "5f299ad5a15bd8980248c045bf1e4948b7033159bdbc7d8bd57890011f2be9fe"
    sha256 cellar: :any,                 arm64_sequoia: "4dc24cd556641d149cc4ddd3a0a11d96d75e2a19e2dc7abfb728e5157a38f809"
    sha256 cellar: :any,                 arm64_sonoma:  "085ced6177fc9a1390c4a401f517ea0bb4c92bc8c5e9aa00636b9442f830dc07"
    sha256 cellar: :any,                 sonoma:        "7b7cb76c9a2a09de91b29dbe0ca5b940a1a170c432612918ec2fa3c407d79e9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "304496df28bef1fc022139489fb5c5f428badd24aa3e4f30e8e03d618f0cec56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38bc73075f593d2ddc29c5eb7e7ce1728b4d3c1143d0d1160fcc06f9987d5dcc"
  end

  depends_on "cmake" => :build

  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    system ENV.cc, "test.c", "#{lib}/#{shared_library("libtmx")}", "-lxml2", "-o", "test"
    system "./test"
  end
end
