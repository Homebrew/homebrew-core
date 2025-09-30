class Wordnet < Formula
  desc "Lexical database for the English language"
  homepage "https://wordnet.princeton.edu/"
  url "https://wordnetcode.princeton.edu/3.0/WordNet-3.0.tar.bz2"
  # Version 3.1 is version 3.0 with the 3.1 dictionary.
  version "3.1"
  sha256 "6c492d0c7b4a40e7674d088191d3aa11f373bb1da60762e098b8ee2dda96ef22"
  license :cannot_represent
  revision 2

  # From homepage: "Princeton WordNet is no longer developed, though the
  # database and all tools are freely available on the download page."
  livecheck do
    skip "No longer developed or maintained"
  end

  bottle do
    sha256                               arm64_tahoe:   "c76614f1a228d94b2470a7b931ae833377ae13d1214cff36d6a93b5fb7da4ae5"
    sha256                               arm64_sequoia: "13c3f71489c21a26e9ccab1c57d9021c705fe548ac756787e2641b90a1eadfb9"
    sha256                               arm64_sonoma:  "3189324a36718d3838b41231d17611873cc112740c6179f1672b66a5f7f02530"
    sha256                               arm64_ventura: "2bce686ad3f16170016ca525ec1908fb76693909f86e7393650e8a411574601a"
    sha256                               sonoma:        "3997310820375bfe93b6cf3512aa70993d47a2a67e54df6140ccbaf736486ada"
    sha256                               ventura:       "323f706e54cc2cb19f4bde6dd703c462337f25763ff8bf9fa52498a10c2a78c7"
    sha256                               arm64_linux:   "3a67f8e72a2b2c2b3119386adefe9ccf353c45bb05598aef4970be2bbe64da1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5090e0ee1251e6d13e6c77024a0d1f18e0b6d563a4ced176d3c2cd1fffb52b7"
  end

  depends_on "tcl-tk@8"

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
    tcltk_lib = Formula["tcl-tk@8"].opt_lib
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-tcl=#{tcltk_lib}",
                          "--with-tk=#{tcltk_lib}"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/wn homebrew -synsn")
    assert_match "alcoholic beverage", output
  end
end
