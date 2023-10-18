class X11vnc < Formula
  desc "VNC server for real X displays"
  homepage "https://github.com/LibVNC/x11vnc"
  license "GPL-2.0-or-later" => { with: "x11vnc-openssl-exception" }
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
    sha256 cellar: :any,                 arm64_sonoma:   "7173e891559711b0819828a51c0e0ba2a2759120b7a1fecabeb03bc0610b9d8a"
    sha256 cellar: :any,                 arm64_ventura:  "149fbe8e1ec220543b848e416642d67c02c291dff1d92be07ab795c5dcff68ae"
    sha256 cellar: :any,                 arm64_monterey: "1a1da7cf49c8db71624ab470a44a19fadeb7a2c7097aee491b84dbd00cf6eae2"
    sha256 cellar: :any,                 arm64_big_sur:  "18957522ad8fcef3f0f402d9c83c0fcf7754af1f05a1319527c1794c59f333de"
    sha256 cellar: :any,                 sonoma:         "5ff6c17ca26d4c50d47371f218696c2ee395ae57a5fe3458c1efb299998ca32f"
    sha256 cellar: :any,                 ventura:        "885177de8737aa58f7af2bbe1321aab8c68280237f2236df74810f1d5122245c"
    sha256 cellar: :any,                 monterey:       "825a2a9601050e1b2170f75f3a3b994262ff973dbcb98fa74155e1a8f5d80260"
    sha256 cellar: :any,                 big_sur:        "1f3fcfd70a28c8af3b95460611f7960c4c3092e8faf564110cd509e2ff9237ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eccdb28862610ff2f7ab45c9fe0de824185981df75454c96fcd4f82532d11e79"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libvncserver"
  depends_on "openssl@3"

  uses_from_macos "libxcrypt"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

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
