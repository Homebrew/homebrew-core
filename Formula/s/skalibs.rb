class Skalibs < Formula
  desc "Skarnet's library collection"
  homepage "https://skarnet.org/software/skalibs/"
  url "https://skarnet.org/software/skalibs/skalibs-2.14.5.0.tar.gz"
  sha256 "d8d9ec756b112ab6d4a9896ba0f53aca92559bc90aeaccd53ed8177e6e159764"
  license "ISC"
  head "git://git.skarnet.org/skalibs.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b0fc5caa5cb1d0bd2f414df97fd0aaef8980d7117fff554366cd433fe35c3045"
    sha256 cellar: :any,                 arm64_sequoia: "d52620b16289f23d72e40e685e9f2699325cc202fb98d690d6989ae164df9375"
    sha256 cellar: :any,                 arm64_sonoma:  "b9ab70785fa56a570a6a94b77d0c9d3adb35fa92057296267242c2eb905da9d2"
    sha256 cellar: :any,                 sonoma:        "af27c1f5e68cd61a223ecab83ee96e4dd025570444556e4f18c835715ed6c724"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fe060b5a388f7488069eed5cf33adfe7682b2b6aaa6d507e5ab210a0baf5725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88892b069629ded15b1ae79ab5be09fc3012efa4c129b5bf5d65bbe9f3bdb050"
  end

  def install
    args = %w[
      --disable-silent-rules
      --enable-shared
      --enable-pkgconfig
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <skalibs/skalibs.h>
      int main() {
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lskarnet", "-o", "test"
    system "./test"
  end
end
