class Traildb < Formula
  desc "Blazingly-fast database for log-structured data"
  homepage "https://traildb.io/"
  url "https://github.com/traildb/traildb/archive/refs/tags/0.6.tar.gz"
  sha256 "f73515fe56c547f861296cf8eecc98b8e8bf00d175ad9fb7f4b981ad7cf8b67c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:    "2595608345bc29813fa5bc78ab86cd54a890e8d6a70e04889ccc3205f8ecd143"
    sha256 arm64_sequoia:  "6855e108a52b0df9a4f13492f09ccf0d8ae7efcb2b25441f88a9d1e214137c4c"
    sha256 arm64_sonoma:   "54903d470c8c610d59b4122f43e3c0292781c8949d5ba8e141f59362e1beb16e"
    sha256 arm64_ventura:  "fc31267f2145da6af9f4cf19609bebd1e4e5f7e468549bb2adbdfd40bd3b50ad"
    sha256 arm64_monterey: "f34fd4ae7821c7f82a44e374e4c07603a63ec224c5ddb441c38e0defcaaeb4a7"
    sha256 arm64_big_sur:  "1889bda4c138dbcf3d7a7229a47705631f2c5880f20a23e3612685c8a1ad7208"
    sha256 sonoma:         "b3d15cca75203e35bc56037c0ec9e1139c54ab909c81ec36a02d7b7ed9daa117"
    sha256 ventura:        "0534a5fd56705faf95c68bd3a4e0ab4b401baaef55d4e8fc37f88126643e5f16"
    sha256 monterey:       "f973d38d9cfe84c422bf98fc4c91265b2d3865efde148fe9b32a2a3af75d44e9"
    sha256 big_sur:        "c86da6038d5ffb50fac4db5af5e0e4cb91c93814fcd712fc4e2697747db2a0a8"
    sha256 arm64_linux:    "3f4b1ec53424608bb138857437b16b36f9ec0ca5272e2833665d1c2280b25a20"
    sha256 x86_64_linux:   "eacba47e211b4e29a1a44507087e2fc1cb501f00c853ee406a0c954c8ba4c47e"
  end

  depends_on "pkgconf" => :build
  depends_on "judy"
  depends_on "libarchive"

  uses_from_macos "python" => :build

  # Update waf script for Python 3
  # Use resource instead of patch since applying corrupts waf
  resource "waf" do
    on_macos do
      url "https://raw.githubusercontent.com/traildb/traildb/053ed8e5d0301c792f3ee703cd9936c49ecf41a1/waf"
      sha256 "2e0cf83a63843da127610420cef1d3126f1187d8e572b6b3a28052fc2250d4bf"
    end
    on_linux do
      # Update `waf` further for Python 3.12+ support. We don't use this on macOS as newer versions
      # fail to find `libarchive` on non-/usr/local prefix due to wscript PKG_CONFIG_PATH override
      url "https://waf.io/waf-2.1.4"
      sha256 "7803d63e698ada49a74ab6979a0fd708a5f9a3456206cba3a3e07387fdcf946d"
    end
  end

  def install
    ENV["PREFIX"] = prefix
    resource("waf").stage { buildpath.install Dir["*"].first => "waf" }
    system "python3", "./waf", "configure", "install"
  end

  test do
    # Check that the library has been installed correctly
    (testpath/"test.c").write <<~C
      #include <traildb.h>
      #include <assert.h>
      int main() {
        const char *path = "test.tdb";
        const char *fields[] = {};
        tdb_cons* c1 = tdb_cons_init();
        assert(tdb_cons_open(c1, path, fields, 0) == 0);
        assert(tdb_cons_finalize(c1) == 0);
        tdb* t1 = tdb_init();
        assert(tdb_open(t1, path) == 0);
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-ltraildb", "-o", "test"
    system "./test"

    # Check that the provided tdb binary works correctly
    (testpath/"in.csv").write("1234 1234\n")
    system bin/"tdb", "make", "-c", "-i", "in.csv", "--tdb-format", "pkg"
  end
end
