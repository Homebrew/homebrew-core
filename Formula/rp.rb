class Rp < Formula
  desc "Tool to find ROP sequences in PE/Elf/Mach-O x86/x64 binaries"
  homepage "https://0vercl0k.github.io/rp/"
  url "https://github.com/0vercl0k/rp/archive/v1.tar.gz"
  version "1.0"
  sha256 "3bf69aee23421ffdc5c7fc3ce6c30eb7510640d384ce58f4a820bae02effebe3"
  head "https://github.com/0vercl0k/rp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f173bd7e78a13f9fe20fbe70e3bda26e91a5aec77bd094a4d0b447afee0ff1b9" => :catalina
    sha256 "9e7dee319426b8db92302fdd19ee37f3ea5b0b3b8ebb1865e29127aa340ec7b5" => :mojave
    sha256 "40042ba7ad3506a62f79ed836480bf2d33a3ea171a19905a51db60c3a037cb0b" => :high_sierra
    sha256 "93aea19e1b6c6511e309f87003f173485a36e2b870734b6162e0bc43ae5f2a70" => :sierra
    sha256 "1ed1c49f3495c6da683908c34d17f345c5f3bde2a5112674bbd41f6a92da1ab2" => :el_capitan
    sha256 "e85fa182a3b46f8a3cd5a6d3a27359d4981fb1cab0ca5c2d3a1a9c471af1a77c" => :yosemite
    sha256 "398c2c7776b0da352930a13a9339cd66b4e74c773313eb347740cfd2ea8ccf24" => :mavericks
  end

  depends_on "cmake" => :build

  # In order to have the same binary name in 32 and 64 bits.
  patch :DATA

  def install
    mkdir "build" do
      system "cmake", ".."
      system "make"
    end
    bin.install "bin/rp-osx"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 79d576b..34c2afa 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -36,12 +36,10 @@ set(RP_NAME "${RP_NAME}-${RP_PLAT}")

 if(CMAKE_SIZEOF_VOID_P EQUAL 8 AND NOT(optX86BUILD))
     set(FLAG_CXX "-m64")
-    set(RP_NAME "${RP_NAME}-x64")
     set(BEA_LIBRARY "BeaEngine.x64.${RP_PLAT}.${EXTENSION_LIBRARY}")
     set(ARGTABLE_LIBRARY "argtable2.x64.${RP_PLAT}.${EXTENSION_LIBRARY}")
 else()
     set(FLAG_CXX "-m32")
-    set(RP_NAME "${RP_NAME}-x86")
     set(BEA_LIBRARY "BeaEngine.x86.${RP_PLAT}.${EXTENSION_LIBRARY}")
     set(ARGTABLE_LIBRARY "argtable2.x86.${RP_PLAT}.${EXTENSION_LIBRARY}")
 endif(CMAKE_SIZEOF_VOID_P EQUAL 8 AND NOT(optX86BUILD))
