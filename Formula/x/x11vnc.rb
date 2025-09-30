class X11vnc < Formula
  desc "VNC server for real X displays"
  homepage "https://github.com/LibVNC/x11vnc"
  url "https://github.com/LibVNC/x11vnc/archive/refs/tags/0.9.17.tar.gz"
  sha256 "3ab47c042bc1c33f00c7e9273ab674665b85ab10592a8e0425589fe7f3eb1a69"
  license "GPL-2.0-or-later" => { with: "x11vnc-openssl-exception" }
  head "https://github.com/LibVNC/x11vnc.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f1a4ed13ffea08fefdfaed2e5b5405a29d302c3e1dfe0ea8f8be69bee9cb4d9c"
    sha256 cellar: :any,                 arm64_sequoia: "04683ae07f04702dffa93bf7fda5c4019e61d64505539c712559ed4dbe82a41d"
    sha256 cellar: :any,                 arm64_sonoma:  "dd9d309ac45e10b7fd969b4dd4d08a63612728ef746c3efffee2317b4c996425"
    sha256 cellar: :any,                 arm64_ventura: "54c171880e9966130ce503f32af1ad3fb48175a86cfe7d07f05bb21a37fca4db"
    sha256 cellar: :any,                 sonoma:        "88e64a8742c4ade347ddc88ccf385b94b02da30b6be1f90cfd9793ff4cfe421b"
    sha256 cellar: :any,                 ventura:       "1a49795ee32fa6a062d2106375a0fc639c3498ab14042e5dd3a8e2af462b574e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0f7c9f45cf87d7609f58dd039c0f0a8ef1c3cfe2eec0afcb5a6d817829b3f82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "676b00ad2fdec853d0f1e29c3b31f33ec88be24b1ec75f1bbf05b4449d9146f4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "libvncserver"
  depends_on "openssl@3"

  uses_from_macos "libxcrypt"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    ENV.append_to_cflags "-Wno-int-conversion" if DevelopmentTools.clang_build_version >= 1500

    system "./autogen.sh", "--disable-silent-rules",
                           "--mandir=#{man}",
                           "--without-x",
                           *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"x11vnc", "--version"
  end
end
