class Tmx < Formula
  desc "Portable C library to load tiled maps in your games"
  homepage "https://github.com/baylej/tmx"
  url "https://github.com/baylej/tmx/archive/tmx_1.0.0.tar.gz"
  sha256 "ba184b722a838a97f514fb7822c1243dbb7be8535b006ef1c5b9f928e295519b"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=on", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.tmx").write <<-EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <map version="1.0" tiledversion="1.0.2" orientation="orthogonal" renderorder="right-down" width="28" height="18" tilewidth="32" tileheight="32" backgroundcolor="#ffff7f" nextobjectid="5">
        <properties>
          <property name="alt" type="file" value="csv.tmx"/>
          <property name="bool_false" type="bool" value="false"/>
          <property name="bool_true" type="bool" value="true"/>
          <property name="colour" type="color" value="#cc1a1a1a"/>
          <property name="multilines">foo
        bar
        baz</property>
          <property name="pi" type="float" value="3.14"/>
          <property name="xml" value="libxml2"/>
        </properties>
        <tileset firstgid="1" name="base" tilewidth="32" tileheight="32" spacing="1" tilecount="9" columns="3">
          <image source="numbers.png" width="100" height="100"/>
          <tile id="0">
          <properties>
            <property name="number" type="int" value="1"/>
          </properties>
          <objectgroup draworder="index">
            <object id="0" x="11.75" y="4.75" width="10.25" height="25.25"/>
          </objectgroup>
          </tile>
          <tile id="1">
          <properties>
            <property name="number" type="int" value="2"/>
          </properties>
          </tile>
          <tile id="2">
          <properties>
            <property name="number" type="int" value="3"/>
          </properties>
          </tile>
          <tile id="4" type="five"/>
          <tile id="6">
          <animation>
            <frame tileid="0" duration="200"/>
            <frame tileid="1" duration="300"/>
            <frame tileid="2" duration="400"/>
            <frame tileid="3" duration="500"/>
            <frame tileid="4" duration="600"/>
            <frame tileid="5" duration="700"/>
            <frame tileid="6" duration="2000"/>
          </animation>
          </tile>
        </tileset>
        <group name="Group">
          <imagelayer name="Image">
          <image source="bg.jpg" width="896" height="576"/>
          <properties>
            <property name="alt" value="rainbow"/>
          </properties>
          </imagelayer>
          <layer name="Layer" width="28" height="18">
          <data encoding="base64" compression="zlib">
          eJy9lN0OgCAIRjX/6v1fuLXZxr7BB9bq4twochioLaVUfqAB11qfyLisYK1nOFsnReztYr8bTsvP9vJ0Yfyq7yno6x/7iuF7mucQRH3WeZYL96y4TZmfVyeueTV4Pq8fXq+YM+Ibk0g9GIv1sX56OTTnGx/mqwTWd80X6T3+ffgPRubNfOjEv0DC3suKTzoHYfV+RtgJlkd7f7fTm4OWi6GdZXNn93H1rqLzBIoiCFE=
          </data>
          </layer>
        </group>
        <objectgroup color="#aa0000" name="Objects">
          <object id="1" name="square" type="spawn" x="128" y="128" width="192" height="192" rotation="22.5"/>
          <object id="2" name="polygon" x="492" y="325">
          <polygon points="20,-5 -44,-197 180,-229"/>
          </object>
          <object id="3" name="polyline" x="174" y="477">
          <polyline points="-14,3 50,-61 114,3 178,-61 242,3 306,-61 370,3"/>
          </object>
          <object id="4" name="ellipse" x="672" y="352" width="160" height="160">
          <ellipse/>
          </object>
          <object id="5" name="text" x="4" y="0" width="110" height="20" rotation="10">
          <text wrap="1" color="#ff0000" bold="1" italic="1">Hello World</text>
          </object>
        </objectgroup>
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
