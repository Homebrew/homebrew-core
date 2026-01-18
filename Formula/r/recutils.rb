class Recutils < Formula
  desc "Tools to work with human-editable, plain text data files"
  homepage "https://www.gnu.org/software/recutils/"
  url "https://ftpmirror.gnu.org/gnu/recutils/recutils-1.9.tar.gz"
  mirror "https://ftp.gnu.org/gnu/recutils/recutils-1.9.tar.gz"
  sha256 "6301592b0020c14b456757ef5d434d49f6027b8e5f3a499d13362f205c486e0e"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:    "1195eef57e411f91d204f23655150667170fdc64242f0503b7e376deb112768a"
    sha256 cellar: :any, arm64_sequoia:  "f1c4d50014f990bf82b005678e5e50d0437c4832db83e80094e0fcfbad824078"
    sha256 cellar: :any, arm64_sonoma:   "229e25a458f74f9b9e1229b08dd839a18f7e06cede1aaecc890b645f645c80e1"
    sha256 cellar: :any, arm64_ventura:  "6556b10f353cbae8cc5d69cc48cb0662eaf85060794e0d29ae25950dbe02749e"
    sha256 cellar: :any, arm64_monterey: "09a875626acf4c73036fc8048bf3e0e5bb7beff7fd60e1e96faa1b1d92888638"
    sha256 cellar: :any, arm64_big_sur:  "c2da94eb14db7fdd4f6376cd3d6546ff8cebddd64f4290fe265161f21d3fdff8"
    sha256 cellar: :any, sonoma:         "06f73515dcef0f167c03853cfaf8e08966cb677ce575b03484f63c69adb182e0"
    sha256 cellar: :any, ventura:        "50252c2587e2e32f0513c9cc71fd49c5786400f6c0d6e95891da4b43a0f873fa"
    sha256 cellar: :any, monterey:       "feac0920394addceefb8a23fc38a7406fed04b71bde433d14dfa703b852c5089"
    sha256 cellar: :any, big_sur:        "8bd10813a8870b76fdac43c99062d3449bd4275ae54af0410c85c69ba3f9ab08"
    sha256 cellar: :any, catalina:       "d92195d721c086a0f14fa0dcdd8014869af600d43e31749a8b8af580f49fafba"
    sha256               arm64_linux:    "57f094907d4b5a4075731cb05a68fb1dd726dc245c914cc695bab138c1362596"
    sha256               x86_64_linux:   "09224d89dd80efca59a618cb2b966ad1a2a1847d992bc27c014fe997db0148af"
  end

  on_linux do
    depends_on "libgcrypt"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Fix compile with newer Clang. Remove in the next release.
    # Ref: http://git.savannah.gnu.org/cgit/recutils.git/commit/?id=e154822aeec19cb790f8618ee740875c048859e4
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--datarootdir=#{elisp}",
                          "--disable-silent-rules",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<~CSV
      a,b,c
      1,2,3
    CSV
    system bin/"csv2rec", "test.csv"

    (testpath/"test.rec").write <<~EOS
      %rec: Book
      %mandatory: Title

      Title: GNU Emacs Manual
    EOS
    system bin/"recsel", "test.rec"
  end
end
