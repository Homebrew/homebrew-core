class X11vnc < Formula
  desc "VNC server for real X displays"
  homepage "https://github.com/LibVNC/x11vnc"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  revision 1
  head "https://github.com/LibVNC/x11vnc.git", branch: "master"

  stable do
    url "https://github.com/LibVNC/x11vnc/archive/0.9.16.tar.gz"
    sha256 "885e5b5f5f25eec6f9e4a1e8be3d0ac71a686331ee1cfb442dba391111bd32bd"

    # Fix build with -fno-common. Remove in the next release
    patch do
      url "https://github.com/LibVNC/x11vnc/commit/a48b0b1cd887d7f3ae67f525d7d334bd2feffe60.patch?full_index=1"
      sha256 "c8c699f0dd4af42a91782df4291459ba2855b22661dc9e6698a0a63ca361a832"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "38324f98f26ae2449c4a6ff17618419edaff6d4bbf9121a72b8148259f86969f"
    sha256 cellar: :any,                 arm64_monterey: "0524eee07eea63fba0608c0b883833d1eaef6968fadeff0a8e9484ecd876b310"
    sha256 cellar: :any,                 arm64_big_sur:  "2a31e43f659772fbeb91cc08be809a70999aaab08855fac54cc62f4620704532"
    sha256 cellar: :any,                 ventura:        "46c01ed3a37614e6c672c704c47d678295b85aedad46a469ac7bd3ec89426efc"
    sha256 cellar: :any,                 monterey:       "5daffa352af06684f3667150491916bf42ed671e0ded33d4b94db65eaf324781"
    sha256 cellar: :any,                 big_sur:        "e657f9d340736e450eebf51336c42f180464e91b179e3ca289eedd5131cf62fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d44a30e51f3ae1de8c80e9b4c3ab492fe22242db0b99e1cc7b5f578839accec4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libvncserver"
  depends_on "openssl@3"

  uses_from_macos "libxcrypt"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl@3"].opt_lib/"pkgconfig"

    system "./autogen.sh", *std_configure_args,
                           "--disable-silent-rules",
                           "--mandir=#{man}",
                           "--without-x"
    system "make", "install"
  end

  test do
    system bin/"x11vnc", "--version"
  end
end
