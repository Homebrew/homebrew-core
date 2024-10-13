class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/3.1/re2c-3.1.tar.xz"
  sha256 "0ac299ad359e3f512b06a99397d025cfff81d3be34464ded0656f8a96676c029"
  license :public_domain

  bottle do
    sha256 arm64_sequoia:  "19a523f3c74c860dfc8ea3c600c60fdcd29e83f5ad21825ffa88b13401283d76"
    sha256 arm64_sonoma:   "b5197fcd4db8b6811e9a72bca29fc08e35d0b0581bc1fa390d17f702fa9af87d"
    sha256 arm64_ventura:  "c213025ac8f67d67c7de7b42b18f02423b9b969f95d01217b0eb082e18e42d02"
    sha256 arm64_monterey: "1132b82eada9b28d6ae914619f6471603986c51490c8bd5c75f64e4a17af7393"
    sha256 arm64_big_sur:  "95c681abedf2a1fa92e68003a76eeb31ecde2d3816a6bb3d01372194a3a86346"
    sha256 sonoma:         "639a90433de77050197aa58c0428986893af29728d905c05718f57f37ce36c27"
    sha256 ventura:        "9d8ed384c1173e7ee72aae6ebc11b2556a501932c33c7c0558f534c1854ce5ac"
    sha256 monterey:       "b6ad0a47af09087b366226d20e9538260e56a80b70bb118bdaf472e82bad1af4"
    sha256 big_sur:        "343c4174f501aaeea7c339fef350d36bd26faffd130d1f07fd778239375fc826"
    sha256 x86_64_linux:   "a30c3862ed53d4e5465ae66cc177253f717a4f611fe5a7533391bd6ca4d0cd72"
  end

  uses_from_macos "python" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      unsigned int stou (const char * s)
      {
      #   define YYCTYPE char
          const YYCTYPE * YYCURSOR = s;
          unsigned int result = 0;

          for (;;)
          {
              /*!re2c
                  re2c:yyfill:enable = 0;

                  "\x00" { return result; }
                  [0-9]  { result = result * 10 + c; continue; }
              */
          }
      }
    EOS
    system bin/"re2c", "-is", testpath/"test.c"
  end
end
