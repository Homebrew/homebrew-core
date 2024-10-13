class Wordnet < Formula
  desc "Lexical database for the English language"
  homepage "https://wordnet.princeton.edu/"
  url "https://wordnetcode.princeton.edu/3.0/WordNet-3.0.tar.bz2"
  # Version 3.1 is version 3.0 with the 3.1 dictionary.
  version "3.1"
  sha256 "6c492d0c7b4a40e7674d088191d3aa11f373bb1da60762e098b8ee2dda96ef22"
  license :cannot_represent
  revision 1

  # This matches WordNet tarball versions as well as database file versions,
  # as these may differ.
  livecheck do
    url "https://wordnet.princeton.edu/download/current-version"
    regex(/href=.*?(?:WordNet|wn)[._-]?v?(\d+(?:\.\d+)+)(?:[._-]dict)?\.t/i)
  end

  bottle do
    sha256                               arm64_sequoia:  "c67aa85468482fee988beffc93bbe3dfa9d7e0f7a99f77e1f380dd6f26b58282"
    sha256                               arm64_sonoma:   "b950541da50b255f77a15f09e713f22472820da7e131c577a4b3f377fc2b44fe"
    sha256                               arm64_ventura:  "57a8ed88c01550f3fc44dd887ddd4ae3c9bbad47ea82c2793bfe167506aacfb6"
    sha256                               arm64_monterey: "6a7414051cb0af96f5b507dd61cd79fa9e63bede15c658bd20569171900e57d3"
    sha256                               arm64_big_sur:  "48c70e44e65ff918d9a7c59999af788a00a29ed67419a411c789ae8e2f29684d"
    sha256                               sonoma:         "27345801fd42201df43c46dbf5e23b912a6df765ffbc74bb419ad8fc534e252a"
    sha256                               ventura:        "897d064747be59d81b16da0b4dd1e34ac187c1d14d3c55399e66c04b3afc503e"
    sha256                               monterey:       "08b97395fa2463e0647a18617f694de1a8cdba61657681e416fc3e96d6df157f"
    sha256                               big_sur:        "603c49d51a805975f31491b9f0faec95900cc9bde2042a3ce042c14ed4a2a808"
    sha256                               catalina:       "56264f8aa182e0fb8d64b0166e2583465b6e373b5d69c7e2247e5ec011467a91"
    sha256                               mojave:         "8fedff541aa821dbee4d0396c2137c1cdc43968e6772a69caa664ffabbc23dbe"
    sha256                               high_sierra:    "2e7eb00a5f63eec2972c927c4e566cf51121e61f95d5f04e4e29443950e3b42f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e2dca6e992ebdeb9f9579b4291fad16955f8838b05b595ee009d4aa21f7a590"
  end

  depends_on "tcl-tk"

  resource "dict" do
    url "https://wordnetcode.princeton.edu/wn3.1.dict.tar.gz"
    sha256 "3f7d8be8ef6ecc7167d39b10d66954ec734280b5bdcd57f7d9eafe429d11c22a"
  end

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    (prefix/"dict").install resource("dict")

    # Disable calling deprecated fields within the Tcl_Interp during compilation.
    # https://bugzilla.redhat.com/show_bug.cgi?id=902561
    ENV.append_to_cflags "-DUSE_INTERP_RESULT"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-tcl=#{Formula["tcl-tk"].opt_prefix}/lib",
                          "--with-tk=#{Formula["tcl-tk"].opt_prefix}/lib"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/wn homebrew -synsn")
    assert_match "alcoholic beverage", output
  end
end
