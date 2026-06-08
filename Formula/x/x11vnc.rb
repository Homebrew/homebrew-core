class X11vnc < Formula
  desc "VNC server for real X displays"
  homepage "https://github.com/LibVNC/x11vnc"
  url "https://github.com/LibVNC/x11vnc/archive/refs/tags/0.9.17.tar.gz"
  sha256 "3ab47c042bc1c33f00c7e9273ab674665b85ab10592a8e0425589fe7f3eb1a69"
  license "GPL-2.0-or-later" => { with: "x11vnc-openssl-exception" }
  revision 1
  head "https://github.com/LibVNC/x11vnc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "102cee00c05c862c030ae03b910f7c8ec47f48248bcc770776887d1d9e132b01"
    sha256 cellar: :any,                 arm64_sequoia: "7ebcb43dc4ccf3d7ac18cf408a2d5d21cc362ff3e7098c9026fb569e532ced4d"
    sha256 cellar: :any,                 arm64_sonoma:  "3e370889f63e85701db1dd0edd825a150618e98fa4f398ace038d20b11c53b9b"
    sha256 cellar: :any,                 sonoma:        "49441c4a528e64ebbee615cb01c827e3de19405439c434f5097727bd981bd59b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f754c6e86c60c7926e3ef94f8b5ca5df4e6970d49ca3e2192b65f36dd90117d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f53a15699255263ebc83de67d31010a0f4c84245a2b3305d82d64b3e5cd5154f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "libvncserver"
  depends_on "openssl@4"

  uses_from_macos "libxcrypt"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    ENV.append_to_cflags "-Wno-int-conversion" if DevelopmentTools.clang_build_version >= 1500
    ENV.append "CFLAGS", "-std=gnu17" if DevelopmentTools.clang_build_version >= 1700

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
