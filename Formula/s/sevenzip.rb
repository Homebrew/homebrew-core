class Sevenzip < Formula
  desc "7-Zip is a file archiver with a high compression ratio"
  homepage "https://7-zip.org"
  url "https://github.com/ip7z/7zip/archive/refs/tags/26.06.tar.gz"
  sha256 "63bbf0ede83e4286ec8a2905ed732a12acc36dd4771984d870b054240ce761fa"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]
  compatibility_version 1
  head "https://github.com/ip7z/7zip.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "25e1b051da85d7feeba001f790743e21639c9a0f1e28fbb30cd9b9eea85a1254"
    sha256 cellar: :any, arm64_tahoe:       "f385225a2542b46ea2bf3e51be8913e04ab3d2f4ed753914621dad85d1439fa4"
    sha256 cellar: :any, arm64_sequoia:     "e124aa458799b02323904f800b05a5442f79efb7818ee3cd654a745c501116a2"
    sha256 cellar: :any, arm64_linux:       "7dc0668db03bad8ee202ecdc903e5d518089a8239a279af9ee303a4334934237"
    sha256 cellar: :any, x86_64_linux:      "195fa267a96d283aa25572655660bbb8d7e6afb79347184d8a8901896c47b819"
  end

  deny_network_access!

  def install
    mac_suffix = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch
    mk_suffix, directory = if OS.mac?
      ["mac_#{mac_suffix}", "m_#{mac_suffix}"]
    else
      ["gcc", "g"]
    end
    cd "CPP/7zip/Bundles/Alone2" do
      system "make", "-f", "../../cmpl_#{mk_suffix}.mak", "DISABLE_RAR_COMPRESS=1"

      # Cherry pick the binary manually. This should be changed to something
      # like `make install' if the upstream adds an install target.
      # See: https://sourceforge.net/p/sevenzip/discussion/45797/thread/1d5b04f2f1/
      bin.install "b/#{directory}/7zz"
    end
    cd "CPP/7zip/Bundles/Format7zF" do
      system "make", "-f", "../../cmpl_#{mk_suffix}.mak", "DISABLE_RAR_COMPRESS=1"
      lib.install "b/#{directory}/7z.so"
      lib.install_symlink "7z.so" => shared_library("lib7z")
    end
  end

  test do
    (testpath/"foo.txt").write("hello world!\n")
    system bin/"7zz", "a", "-t7z", "foo.7z", "foo.txt"
    system bin/"7zz", "e", "foo.7z", "-oout"
    assert_equal "hello world!\n", (testpath/"out/foo.txt").read

    (testpath/"test7z.c").write <<~C
      #include <stdint.h>
      #include <stdio.h>
      #include <string.h>

      typedef int32_t HRESULT;
      #define S_OK ((HRESULT)0L)
      #define SUCCEEDED(hr) (((HRESULT)(hr)) >= 0)

      typedef uint16_t VARTYPE;
      #define VT_UI4 19

      typedef struct tagPROPVARIANT {
        VARTYPE vt;
        uint16_t wReserved1;
        uint16_t wReserved2;
        uint16_t wReserved3;
        union {
          uint32_t ulVal;
          int32_t  lVal;
          uint64_t uhVal;
          int64_t  hVal;
          int16_t  iVal;
          uint16_t uiVal;
          char     cVal;
          unsigned char bVal;
          int      intVal;
          unsigned int uintVal;
        };
      } PROPVARIANT;

      typedef int PROPID;

      HRESULT GetModuleProp(PROPID propID, PROPVARIANT *value);

      int main(void) {
        PROPVARIANT val;
        memset(&val, 0, sizeof(val));

        HRESULT hr = GetModuleProp(1, &val); // 1 = kVersion

        if (!SUCCEEDED(hr) || val.vt != VT_UI4) {
          printf("GetModuleProp failed\\n");
          return 1;
        }

        unsigned major = val.ulVal >> 16;
        unsigned minor = val.ulVal & 0xFFFF;

        printf("%02u.%02u", major, minor);
        return 0;
      }
    C

    system ENV.cc, "test7z.c", "-L#{lib}", "-l7z", "-o", "test7z"
    output = shell_output("./test7z").strip
    assert_equal version.to_s, output
  end
end
