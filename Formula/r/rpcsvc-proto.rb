class RpcsvcProto < Formula
  desc "Rpcsvc protocol definitions from glibc"
  homepage "https://github.com/thkukuk/rpcsvc-proto"
  url "https://github.com/thkukuk/rpcsvc-proto/releases/download/v1.4.4/rpcsvc-proto-1.4.4.tar.xz"
  sha256 "81c3aa27edb5d8a18ef027081ebb984234d5b5860c65bd99d4ac8f03145a558b"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "4bbc594d97b03ddb65f8a7caaf4521cd12c5a7bc463f3e4c051d5ff08dd010b1"
    sha256 cellar: :any,                 arm64_sequoia:  "076bec1fd5bdddb95185b92aa72a11b94e72cece029eb771edabe98cf805b91d"
    sha256 cellar: :any,                 arm64_sonoma:   "af9f762a02610698572a23013b726055104c910c96d1d9f0dd5173261f0989a1"
    sha256 cellar: :any,                 arm64_ventura:  "af81bdfc3e4e2ba5e41993f84e71ad26054d91a92bb9e65532e6fd6e553c53ea"
    sha256 cellar: :any,                 arm64_monterey: "65f7f9272dd8f9ad6bf4de8a8c31c2dfc80ab7f02ad44e8321e5cd1472f710f3"
    sha256 cellar: :any,                 sonoma:         "f140baf7a5cf933905991ed2e683dd0ec0aac61538e58c03e614300d5d399f9a"
    sha256 cellar: :any,                 ventura:        "07342449582194d02bf19968decfba8f15443bd9d104d681ed1fb00c218619d7"
    sha256 cellar: :any,                 monterey:       "4553fc6e7525cb0d22c9ee9959eac99d6f00ae22529097d8800c31f30e6c6475"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "466aa9b9b6c1df9be8a1dd57f8c71aeee487d6a2d0eb8d54d593d1074e35fcb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f595f1a5c182488fe70c250ae8b6c37064231380b521498390bf6964ad0c0d0"
  end

  keg_only :shadowed_by_macos

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "nettype", shell_output("#{bin}/rpcgen 2>&1", 1)

    (testpath/"msg.x").write <<~EOS
      program MESSAGEPROG {
        version PRINTMESSAGEVERS {
          int PRINTMESSAGE(string) = 1;
        } = 1;
      } = 0x20000001;
    EOS
    system bin/"rpcgen", "msg.x"
    assert_path_exists "msg_svc.c"
  end
end
