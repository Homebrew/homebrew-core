class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v7.8.1.tar.gz"
  sha256 "204473f377bdfd2aa2c9fa71074dad799e1848d91510d41c2f36ec0edcf5bc43"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "df1f0fbd4ed2bae86b8d9936c4fe627f8a36f828cb6e04da29748bcf68fadcf8"
    sha256 arm64_sequoia: "7356dc0b35c377c8b2229769057307397ede2587d8d9a0939b956146455c2397"
    sha256 arm64_sonoma:  "59952921fd9c00bc0e8b91c675188343688807f7fdb58eba826f72613aea2ea9"
    sha256 sonoma:        "c359095240ae74fc15b8eed7bc4d1f514bb95e111e4ddca0c066709a41c7c048"
    sha256 arm64_linux:   "39adc3e4756a29ce10af721b04cc3fbfed41442a6c51a0caa3d08bc1e3bf28da"
    sha256 x86_64_linux:  "c8cfd737fa13a36bf8471360a358d4739a2fed0b835430c6489b6fa1b286346d"
  end

  depends_on "brotli"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--enable-color",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    assert_match "Hello World!", shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match "Hello World!", shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end
