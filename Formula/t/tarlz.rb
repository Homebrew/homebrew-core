class Tarlz < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/tarlz.html"
  url "https://download.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.33.tar.lz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.33.tar.lz"
  sha256 "5df763a8ae2c2bcb94a87294630db2fe3ca827aeb21354d6f2215ed1dcca7970"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/tarlz/"
    regex(/href=.*?tarlz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a7f25f5fe5ff8bb768e6514541a8a13131cccf6b29bfe2fb694f01a8184aae89"
    sha256 cellar: :any, arm64_tahoe:       "4c0a448aace9c239320873476430fd97ae216c4dfe5ca7d03bd0524990ebd223"
    sha256 cellar: :any, arm64_sequoia:     "ab959257b677e8d0f25ded756a4c9af32cb2f3347e5b97616d2c2e0456e11597"
    sha256 cellar: :any, arm64_linux:       "9822adcd3dc14a1697806e6efe742eb623a58e9f13c012895326aa77dd294cc5"
    sha256 cellar: :any, x86_64_linux:      "105e82146d7a36e68ed4c9ac8a09d2b21765aa1b759f0fff84c0c65aff482243"
  end

  depends_on "lzlib"

  deny_network_access!

  def install
    system "./configure", *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    archive = testpath/"test.tar.lz"
    (testpath/"source/test.txt").write "TEST CONTENT"
    (dest = testpath/"destination").mkpath

    system bin/"tarlz", "-C", testpath, "-cf", archive, "source"
    assert_path_exists archive

    system bin/"tarlz", "-C", dest, "-xf", archive
    assert_equal "TEST CONTENT", (dest/"source/test.txt").read
  end
end
