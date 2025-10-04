class Reop < Formula
  desc "Encrypted keypair management"
  homepage "https://flak.tedunangst.com/post/reop"
  url "https://flak.tedunangst.com/files/reop-2.1.1.tgz"
  mirror "https://bo.mirror.garr.it/OpenBSD/distfiles/reop-2.1.1.tgz"
  sha256 "fa8ae058c51efec5bde39fab15b4275e6394d9ab1dd2190ffdba3cf9983fdcac"
  license "ISC"
  revision 1

  livecheck do
    skip "No longer developed"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "95b75472fc27e78edb5a78cfce5ee11eab88c09ba2b3344d50f55189c055c038"
    sha256 cellar: :any,                 arm64_sequoia:  "b1329c9bb7f9a9adb0ccf90c4c045cfa032215406f48c4fbe5d5f010019091a9"
    sha256 cellar: :any,                 arm64_sonoma:   "0a34d7d7270cd31264c8064b44f2fd1475a6edec8d159f2455ba6d5f6a5dce80"
    sha256 cellar: :any,                 arm64_ventura:  "8068e06ca891b71c1a18097fff6be93b18f56bade43aa6855d1490dfef7ad4c4"
    sha256 cellar: :any,                 arm64_monterey: "55cc0d36de154d5a561c5f02c64ea5498283cf83eba356433712e17f9be81a15"
    sha256 cellar: :any,                 sonoma:         "743de0a38cb6ec3d1f7988376bccd80f9a5b8501b72d4bd0812118e17b63644b"
    sha256 cellar: :any,                 ventura:        "c89f4b388723c96fc8152e3d95d5817ca8dc66f1b23fe62c37bf0d26b33ceb8d"
    sha256 cellar: :any,                 monterey:       "04fa8b5abe8bf9c8064a70c32393933339a60f66e3306d95e44b5748b1a960b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "566db99533e99f809e5fe5dac5f9f671c2612139c0e51099c0b328cbdb7f2f9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39a6b6aaa92dc34131e9ecf9c22a8ef890b8d662960a5dba258bb58f87d71516"
  end

  depends_on "libsodium"

  def install
    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    inreplace "GNUmakefile", "${LDFLAGS} ${OBJS}", "${OBJS} ${LDFLAGS}"

    system "make", "-f", "GNUmakefile"
    bin.install "reop"
    man1.install "reop.1"
  end

  test do
    (testpath/"pubkey").write <<~EOS
      -----BEGIN REOP PUBLIC KEY-----
      ident:root
      RWRDUxZNDeX4wcynGeCr9Bro6Ic7s1iqi1XHYacEaHoy+7jOP+ZE0yxR+2sfaph2MW15e8eUZvvI
      +lxZaqFZR6Kc4uVJnvirIK97IQ==
      -----END REOP PUBLIC KEY-----
    EOS

    (testpath/"msg").write <<~EOS
      testing one two three four
    EOS

    (testpath/"sig").write <<~EOS
      -----BEGIN REOP SIGNATURE-----
      ident:root
      RWQWTQ3l+MHMpx8RO/+BX/xxHn0PiSneiJ1Au2GurAmx4L942nZFBRDOVw2xLzvp/RggTVTZ46k+
      GLVjoS6fSuLneCfaoRlYHgk=
      -----END REOP SIGNATURE-----
    EOS

    system bin/"reop", "-V", "-x", "sig", "-p", "pubkey", "-m", "msg"
  end
end
