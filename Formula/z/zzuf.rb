class Zzuf < Formula
  desc "Transparent application input fuzzer"
  homepage "http://caca.zoy.org/wiki/zzuf"
  url "https://github.com/samhocevar/zzuf/releases/download/v0.15/zzuf-0.15.tar.bz2"
  sha256 "04353d94c68391b3945199f100ab47fc5ff7815db1e92581a600d4175e3a6872"
  license "WTFPL"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:    "a4c4c66658aa63cc815d056e06bce100d7907cfd53179b98b596f440a1d0cd15"
    sha256                               arm64_sequoia:  "6ccb5e6621aa95f4cb62afebe5f4c3aee322b8d207a10d3cbdc16bb073c09aa5"
    sha256                               arm64_sonoma:   "6fce95c82da3ed7282dfbc55f4b276910b78fa5d76b2d5e66ad9b43607828fcf"
    sha256                               arm64_ventura:  "16fc98439ca072e8cf19c129649eff99e63e0cece1c1455e97f04ce7cb4dfd73"
    sha256                               arm64_monterey: "8cf189e969a94737e6729be772df9f64759b7c33580cee51d571b31365dbddf2"
    sha256                               arm64_big_sur:  "7ff801dd276cdd8f830d07d01c97a83207ed8ac77c6023ff21b29a2ec536637b"
    sha256                               sonoma:         "e6a2bcac4710033bd155592753c6d4446a3771c70a9cdaa86f34a33f968db122"
    sha256                               ventura:        "397eb044876f87b27787679b9a8f965da0aca9251386aa2a6dbbd1b5ef8cd3c9"
    sha256                               monterey:       "2cfa284477cd1e81ac3b248a20f25812083fe7b592a997ecbefee7663cedab91"
    sha256                               big_sur:        "284b235c4c744d7be86fbe6175a8d67a743a429c8021437182a31e6184105437"
    sha256                               catalina:       "809edd89cf9bd285a0f5496500627aca8b4b4cec071bfd747eb7ae3918526ae6"
    sha256                               arm64_linux:    "c7c8ec8267f9b314e98b81cd5bb9a9765b51d1bce2f4dfd00798ac823affd99e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7164c38ad977edfad3d137b9071e22f185effde9165996e847facd20f4df0e65"
  end

  head do
    url "https://github.com/samhocevar/zzuf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkgconf" => :build
  end

  def install
    system "./bootstrap" if build.head?

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    ENV.append_to_cflags "-Wno-int-conversion" if DevelopmentTools.clang_build_version >= 1500

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/zzuf -i -B 4194304 -r 0.271828 -s 314159 -m < /dev/zero").chomp
    assert_equal "zzuf[s=314159,r=0.271828]: 549e1200590e9c013e907039fe535f41", output
  end
end
