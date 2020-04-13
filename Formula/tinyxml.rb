class Tinyxml < Formula
  desc "XML parser"
  homepage "http://www.grinninglizard.com/tinyxml/"
  url "https://downloads.sourceforge.net/project/tinyxml/tinyxml/2.6.2/tinyxml_2_6_2.tar.gz"
  sha256 "15bdfdcec58a7da30adc87ac2b078e4417dbe5392f3afb719f9ba6d062645593"

  bottle do
    cellar :any
    sha256 "7cc1ada5d273bec9f50a1809a9989306ec9601a037c06b362cee321fbdc5c0a7" => :catalina
    sha256 "c1fc1d7fa9e6934412294e921cde90bcfd107b68dbdddd9acf8cae4927190718" => :mojave
    sha256 "ec0f83018a9ff93c11b6a8c92483056b2771359a14aedfb6dc46e1ab078ce9ac" => :high_sierra
    sha256 "ef8c7bbbae6148e161b6f3369ede8bd3533a32847dc716000b46d26e6fb1c26c" => :sierra
    sha256 "16e6052892b43e68c45f5122b6802e9bc32001dc9478dfcd89511a24544660e5" => :el_capitan
    sha256 "4b1df9cb229b04f9968621a52737d96e86fcd6c2ad8904ae8a5c324347845f50" => :yosemite
    sha256 "75f79bb5d502e7be74de20e1cd3e3dcdd4702b37ef7de53d9d9a546a51776b50" => :mavericks
  end

  depends_on "cmake" => :build

  # The first two patches are taken from the debian packaging of tinyxml.
  #   The first patch enforces use of stl strings, rather than a custom string type.
  #   The second patch is a fix for incorrect encoding of elements with special characters
  #   originally posted at https://sourceforge.net/p/tinyxml/patches/51/
  # The third patch adds a CMakeLists.txt file to build a shared library and provide an install target
  #   submitted upstream as https://sourceforge.net/p/tinyxml/patches/66/
  patch do
    url "https://raw.githubusercontent.com/robotology/yarp/59eedfbaa1069aa5f03a4a9980d984d59decd55c/extern/tinyxml/patches/enforce-use-stl.patch"
    sha256 "16a5b5e842eb0336be606131e5fb12a9165970f7bd943780ba09df2e1e8b29b1"
  end

  patch do
    url "https://raw.githubusercontent.com/robotology/yarp/59eedfbaa1069aa5f03a4a9980d984d59decd55c/extern/tinyxml/patches/entity-encoding.patch"
    sha256 "c5128e03933cd2e22eb85554d58f615f4dbc9177bd144cae2913c0bd7b140c2b"
  end

  patch do
    url "https://gist.githubusercontent.com/scpeters/6325123/raw/cfb079be67997cb19a1aee60449714a1dedefed5/tinyxml_CMakeLists.patch"
    sha256 "32160135c27dc9fb7f7b8fb6cf0bf875a727861db9a07cf44535d39770b1e3c7"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    (lib+"pkgconfig/tinyxml.pc").write pc_file
  end

  def pc_file
    <<~EOS
      prefix=#{opt_prefix}
      exec_prefix=${prefix}
      libdir=${exec_prefix}/lib
      includedir=${prefix}/include

      Name: TinyXml
      Description: Simple, small, C++ XML parser
      Version: #{version}
      Libs: -L${libdir} -ltinyxml
      Cflags: -I${includedir}
    EOS
  end

  test do
    (testpath/"test.xml").write <<~EOS
      <?xml version="1.0" ?>
      <Hello>World</Hello>
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include <tinyxml.h>

      int main()
      {
        TiXmlDocument doc ("test.xml");
        doc.LoadFile();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-ltinyxml", "-o", "test"
    system "./test"
  end
end
