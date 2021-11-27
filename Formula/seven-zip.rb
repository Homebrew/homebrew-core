class SevenZip < Formula
  desc "File archiver with a high compression ratio"
  homepage "https://www.7-zip.org/"
  url "https://www.7-zip.org/a/7z2106-src.7z"
  version "21.06"
  sha256 "675eaa90de3c6a3cd69f567bba4faaea309199ca75a6ad12bac731dcdae717ac"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]

  # Remove non-free RAR sources
  patch :DATA

  def install
    tool = OS.mac? ? "mac" : "gcc"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"

    cd "CPP/7zip/Bundles/Alone2"
    system "make", "-f", "../../cmpl_#{tool}_#{arch}.mak"
    bin.install "b/m_#{arch}/7zz"
  end

  test do
    (testpath/"foo.txt").write("hello world!\n")
    system bin/"7zz", "a", "-t7z", "foo.7z", "foo.txt"
    system bin/"7zz", "e", "foo.7z", "-oout"
    assert_equal "hello world!\n", File.read(testpath/"out/foo.txt")
  end
end

__END__
diff --git a/CPP/7zip/7zip_gcc.mak b/CPP/7zip/7zip_gcc.mak
index 5fa03e7..7340d47 100644
--- a/CPP/7zip/7zip_gcc.mak
+++ b/CPP/7zip/7zip_gcc.mak
@@ -530,11 +530,6 @@ $O/NsisIn.o: ../../Archive/Nsis/NsisIn.cpp
 $O/NsisRegister.o: ../../Archive/Nsis/NsisRegister.cpp
 	$(CXX) $(CXXFLAGS) $<
 
-$O/Rar5Handler.o: ../../Archive/Rar/Rar5Handler.cpp
-	$(CXX) $(CXXFLAGS) $<
-$O/RarHandler.o: ../../Archive/Rar/RarHandler.cpp
-	$(CXX) $(CXXFLAGS) $<
-
 $O/TarHandler.o: ../../Archive/Tar/TarHandler.cpp
 	$(CXX) $(CXXFLAGS) $<
 $O/TarHandlerOut.o: ../../Archive/Tar/TarHandlerOut.cpp
@@ -664,18 +659,6 @@ $O/PpmdZip.o: ../../Compress/PpmdZip.cpp
 	$(CXX) $(CXXFLAGS) $<
 $O/QuantumDecoder.o: ../../Compress/QuantumDecoder.cpp
 	$(CXX) $(CXXFLAGS) $<
-$O/Rar1Decoder.o: ../../Compress/Rar1Decoder.cpp
-	$(CXX) $(CXXFLAGS) $<
-$O/Rar2Decoder.o: ../../Compress/Rar2Decoder.cpp
-	$(CXX) $(CXXFLAGS) $<
-$O/Rar3Decoder.o: ../../Compress/Rar3Decoder.cpp
-	$(CXX) $(CXXFLAGS) $<
-$O/Rar3Vm.o: ../../Compress/Rar3Vm.cpp
-	$(CXX) $(CXXFLAGS) $<
-$O/Rar5Decoder.o: ../../Compress/Rar5Decoder.cpp
-	$(CXX) $(CXXFLAGS) $<
-$O/RarCodecsRegister.o: ../../Compress/RarCodecsRegister.cpp
-	$(CXX) $(CXXFLAGS) $<
 $O/ShrinkDecoder.o: ../../Compress/ShrinkDecoder.cpp
 	$(CXX) $(CXXFLAGS) $<
 $O/XpressDecoder.o: ../../Compress/XpressDecoder.cpp
@@ -708,12 +691,6 @@ $O/Pbkdf2HmacSha1.o: ../../Crypto/Pbkdf2HmacSha1.cpp
 	$(CXX) $(CXXFLAGS) $<
 $O/RandGen.o: ../../Crypto/RandGen.cpp
 	$(CXX) $(CXXFLAGS) $<
-$O/Rar20Crypto.o: ../../Crypto/Rar20Crypto.cpp
-	$(CXX) $(CXXFLAGS) $<
-$O/Rar5Aes.o: ../../Crypto/Rar5Aes.cpp
-	$(CXX) $(CXXFLAGS) $<
-$O/RarAes.o: ../../Crypto/RarAes.cpp
-	$(CXX) $(CXXFLAGS) $<
 $O/WzAes.o: ../../Crypto/WzAes.cpp
 	$(CXX) $(CXXFLAGS) $<
 $O/ZipCrypto.o: ../../Crypto/ZipCrypto.cpp
diff --git a/CPP/7zip/Bundles/Format7zF/Arc_gcc.mak b/CPP/7zip/Bundles/Format7zF/Arc_gcc.mak
index 18fa41b..82da04b 100644
--- a/CPP/7zip/Bundles/Format7zF/Arc_gcc.mak
+++ b/CPP/7zip/Bundles/Format7zF/Arc_gcc.mak
@@ -175,10 +175,6 @@ NSIS_OBJS = \
   $O/NsisIn.o \
   $O/NsisRegister.o \
 
-RAR_OBJS = \
-  $O/RarHandler.o \
-  $O/Rar5Handler.o \
-
 TAR_OBJS = \
   $O/TarHandler.o \
   $O/TarHandlerOut.o \
@@ -245,12 +241,6 @@ COMPRESS_OBJS = \
   $O/PpmdRegister.o \
   $O/PpmdZip.o \
   $O/QuantumDecoder.o \
-  $O/Rar1Decoder.o \
-  $O/Rar2Decoder.o \
-  $O/Rar3Decoder.o \
-  $O/Rar3Vm.o \
-  $O/Rar5Decoder.o \
-  $O/RarCodecsRegister.o \
   $O/ShrinkDecoder.o \
   $O/XpressDecoder.o \
   $O/XzDecoder.o \
@@ -269,9 +259,6 @@ CRYPTO_OBJS = \
   $O/MyAesReg.o \
   $O/Pbkdf2HmacSha1.o \
   $O/RandGen.o \
-  $O/Rar20Crypto.o \
-  $O/Rar5Aes.o \
-  $O/RarAes.o \
   $O/WzAes.o \
   $O/ZipCrypto.o \
   $O/ZipStrong.o \
@@ -336,7 +323,6 @@ ARC_OBJS = \
   $(COM_OBJS) \
   $(ISO_OBJS) \
   $(NSIS_OBJS) \
-  $(RAR_OBJS) \
   $(TAR_OBJS) \
   $(UDF_OBJS) \
   $(WIM_OBJS) \
