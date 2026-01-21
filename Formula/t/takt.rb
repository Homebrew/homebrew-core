class Takt < Formula
  desc "Text-based music programming language"
  homepage "https://takt.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/takt/takt-0.310-src.tar.gz"
  sha256 "eb2947eb49ef84b6b3644f9cf6f1ea204283016c4abcd1f7c57b24b896cc638f"
  license "GPL-2.0-or-later"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "fb1c2a27bc7182659239d0ef52d07617a56aa6e0fb1498f531cd12e7b045d434"
    sha256 arm64_sequoia:  "89999aa891436126770e5d390013ec55a9f2eff6e569e046443de74b9cd648d5"
    sha256 arm64_sonoma:   "9cf5685481804bc8482d1f8d9eaa3b7e41465e70e8d04662e81243d9ac139aef"
    sha256 arm64_ventura:  "d9787c5847508262a9e7f4e61165e94c80a39efc54587a804a2fc20904acf42b"
    sha256 arm64_monterey: "1e8949e4e3457701233d4f72fd01e9852dafc3e1373124b9de0eaa08b7f6dca9"
    sha256 arm64_big_sur:  "910a1325ce07065c113c1efd53e8295a10b8db613ef6fa1e5bfda1abc8fa922d"
    sha256 sonoma:         "c1ab777ee7c89e4897a4d7cc7b115fb29a0acedb46b5fbfaf40368c78ed34cdb"
    sha256 ventura:        "47084647d30b62e5b76dbad42b93aec1e4aa21ab16b4b326be2e783c14b128af"
    sha256 monterey:       "4a3a4bf1b60b32d06bd0fd687e1fbb67684432db141aaf0acd0dcf54b8f5f00e"
    sha256 big_sur:        "fd9dec43c0d9d5634d3bf23f8c6112090429d279243c5c0acd4dbfff8025fdbc"
    sha256 catalina:       "b5f6d5891f4955b26be88358c37199d9f9b1ebd66eaaa519ccbcfddbfa615780"
    sha256 arm64_linux:    "d770c92134e4a2e483ff3d4f9371647ed5b688ab8f019d073917689927412a05"
    sha256 x86_64_linux:   "f448f82ff76bc5ea174cab0648cadca7d547688a783c424ab5e7a68a41fe8839"
  end

  depends_on "readline"

  on_linux do
    depends_on "alsa-lib"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    system "./configure", "--prefix=#{prefix}", "--with-lispdir=#{elisp}"
    system "make", "install"
  end

  test do
    system bin/"takt", "-o etude1.mid", pkgshare/"examples/etude1.takt"
  end
end
