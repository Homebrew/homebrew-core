class Sevenzip < Formula
  desc "7-Zip is a file archiver with a high compression ratio"
  homepage "https://7-zip.org"
  url "https://github.com/ip7z/7zip/releases/download/26.03/7z2603-src.tar.xz"
  sha256 "9cbde5099c6deb73691b0579063da5827522ccbbcba3f0020fd04e8c8c16c0d4"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]
  compatibility_version 1
  head "https://github.com/ip7z/7zip.git", branch: "main"

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "253b07aca4d56ccf849cd025beeaee2db98815571195c4027c84b1a91690d274"
    sha256 cellar: :any, arm64_sequoia: "8e14d4dbe8fb93a9b08a0c4be9aae22d561b28d1eaf423f7a0ed0ddd94b5b1b2"
    sha256 cellar: :any, arm64_sonoma:  "5833969c107401708c0ff136d79031831ae606e3d57962487ff85a71aa1bca50"
    sha256 cellar: :any, arm64_linux:   "2b45a5c63c107874244eda5175db8b2f32053fed9f58f1ba71959308a431a70e"
    sha256 cellar: :any, x86_64_linux:  "dbf1f812d853a75b2df4bdf2642094509d12dc05db52f3810687566866cef0ad"
  end

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
