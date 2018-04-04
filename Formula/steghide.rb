class Steghide < Formula
  desc "Steganography program able to hide data in various kinds of files"
  homepage "https://steghide.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/steghide/steghide/0.5.1/steghide-0.5.1.tar.gz"
  sha256 "78069b7cfe9d1f5348ae43f918f06f91d783c2b3ff25af021e6a312cf541b47b"

  depends_on "mhash"
  depends_on "mcrypt"
  depends_on "jpeg"
  depends_on "gettext"

  depends_on "libtool" => :build

  # Reported to upstream at 04 Apr 2018
  # via steghide-devel mailing list on sourceforge
  # Project is pretty much dead though
  patch :DATA

  def install
    ENV["LIBTOOL"] = "glibtool"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"

    # We can't use brew test fixtures since they're too small, so test
    # jpg file is copied to prefix to be used in test do block
    cp "tests/data/std.jpg", prefix/"test-file.jpg"
  end

  test do
    cd testpath do
      File.write "hideme.txt", "Super sensitive stuff"

      # See comment in the end of install
      testfile = prefix/"test-file.jpg"

      system bin/"steghide", "embed", "-cf", testfile, "-sf", "stego.jpg",
                             "-ef", "hideme.txt", "-p", "OhHiMark"
      system bin/"steghide", "extract", "-sf", "stego.jpg",
                             "-xf", "unhide.txt", "-p", "OhHiMark"

      assert_equal File.read("hideme.txt"), File.read("unhide.txt")
    end
  end
end

__END__
diff --git a/src/AuData.h b/src/AuData.h
index b4ccc9ae6375..d287c5ad7a6f 100644
--- a/src/AuData.h
+++ b/src/AuData.h
@@ -26,22 +26,22 @@
 
 // AuMuLawAudioData
 typedef AudioDataImpl<AuMuLaw,BYTE> AuMuLawAudioData ;
-inline BYTE AuMuLawAudioData::readValue (BinaryIO* io) const { return (io->read8()) ; }
-inline void AuMuLawAudioData::writeValue (BinaryIO* io, BYTE v) const { io->write8(v) ; }
+template<> inline BYTE AuMuLawAudioData::readValue (BinaryIO* io) const { return (io->read8()) ; }
+template<> inline void AuMuLawAudioData::writeValue (BinaryIO* io, BYTE v) const { io->write8(v) ; }
 
 // AuPCM8AudioData
 typedef AudioDataImpl<AuPCM8,SBYTE> AuPCM8AudioData ;
-inline SBYTE AuPCM8AudioData::readValue (BinaryIO* io) const { return ((SBYTE) io->read8()) ; }
-inline void AuPCM8AudioData::writeValue (BinaryIO* io, SBYTE v) const { io->write8((BYTE) v) ; }
+template<> inline SBYTE AuPCM8AudioData::readValue (BinaryIO* io) const { return ((SBYTE) io->read8()) ; }
+template<> inline void AuPCM8AudioData::writeValue (BinaryIO* io, SBYTE v) const { io->write8((BYTE) v) ; }
 
 // AuPCM16AudioData
 typedef AudioDataImpl<AuPCM16,SWORD16> AuPCM16AudioData ;
-inline SWORD16 AuPCM16AudioData::readValue (BinaryIO* io) const { return ((SWORD16) io->read16_be()) ; }
-inline void AuPCM16AudioData::writeValue (BinaryIO* io, SWORD16 v) const { io->write16_be((UWORD16) v) ; }
+template<> inline SWORD16 AuPCM16AudioData::readValue (BinaryIO* io) const { return ((SWORD16) io->read16_be()) ; }
+template<> inline void AuPCM16AudioData::writeValue (BinaryIO* io, SWORD16 v) const { io->write16_be((UWORD16) v) ; }
 
 // AuPCM32AudioData
 typedef AudioDataImpl<AuPCM32,SWORD32> AuPCM32AudioData ;
-inline SWORD32 AuPCM32AudioData::readValue (BinaryIO* io) const { return ((SWORD32) io->read32_be()) ; }
-inline void AuPCM32AudioData::writeValue (BinaryIO* io, SWORD32 v) const { io->write32_be((UWORD32) v) ; }
+template<> inline SWORD32 AuPCM32AudioData::readValue (BinaryIO* io) const { return ((SWORD32) io->read32_be()) ; }
+template<> inline void AuPCM32AudioData::writeValue (BinaryIO* io, SWORD32 v) const { io->write32_be((UWORD32) v) ; }
 
 #endif // ndef SH_AUDATA_H
diff --git a/src/AuSampleValues.cc b/src/AuSampleValues.cc
index 64709f3e2e18..f5b4ff5a43a2 100644
--- a/src/AuSampleValues.cc
+++ b/src/AuSampleValues.cc
@@ -21,17 +21,17 @@
 #include "AuSampleValues.h"
 
 // AuMuLawSampleValue
-const BYTE AuMuLawSampleValue::MinValue = 0 ;
-const BYTE AuMuLawSampleValue::MaxValue = BYTE_MAX ;
+template<> const BYTE AuMuLawSampleValue::MinValue = 0 ;
+template<> const BYTE AuMuLawSampleValue::MaxValue = BYTE_MAX ;
 
 // AuPCM8SampleValue
-const SBYTE AuPCM8SampleValue::MinValue = SBYTE_MIN ;
-const SBYTE AuPCM8SampleValue::MaxValue = SBYTE_MAX ;
+template<> const SBYTE AuPCM8SampleValue::MinValue = SBYTE_MIN ;
+template<> const SBYTE AuPCM8SampleValue::MaxValue = SBYTE_MAX ;
 
 // AuPCM16SampleValue
-const SWORD16 AuPCM16SampleValue::MinValue = SWORD16_MIN ;
-const SWORD16 AuPCM16SampleValue::MaxValue = SWORD16_MAX ;
+template<> const SWORD16 AuPCM16SampleValue::MinValue = SWORD16_MIN ;
+template<> const SWORD16 AuPCM16SampleValue::MaxValue = SWORD16_MAX ;
 
 // AuPCM32SampleValue
-const SWORD32 AuPCM32SampleValue::MinValue = SWORD32_MIN ;
-const SWORD32 AuPCM32SampleValue::MaxValue = SWORD32_MAX ;
+template<> const SWORD32 AuPCM32SampleValue::MinValue = SWORD32_MIN ;
+template<> const SWORD32 AuPCM32SampleValue::MaxValue = SWORD32_MAX ;
diff --git a/src/MHashPP.cc b/src/MHashPP.cc
index 27b3d73ae18d..b10900d5cbb2 100755
--- a/src/MHashPP.cc
+++ b/src/MHashPP.cc
@@ -120,7 +120,7 @@ std::string MHashPP::getAlgorithmName ()
 
 std::string MHashPP::getAlgorithmName (hashid id)
 {
-	char *name = mhash_get_hash_name (id) ;
+	char *name = (char*) mhash_get_hash_name (id) ;
 	std::string retval ;
 	if (name == NULL) {
 		retval = std::string ("<algorithm not found>") ;
diff --git a/src/Makefile.in b/src/Makefile.in
index 75c2acea1fbb..400204bc230a 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -190,7 +190,6 @@ WavChunkHeader.cc WavChunkUnused.cc WavFile.cc WavFormatChunk.cc \
 WavPCMSampleValue.cc error.cc main.cc msg.cc SMDConstructionHeuristic.cc
 
 localedir = $(datadir)/locale
-LIBTOOL = $(SHELL) libtool
 MAINTAINERCLEANFILES = Makefile.in
 subdir = src
 mkinstalldirs = $(SHELL) $(top_srcdir)/mkinstalldirs

