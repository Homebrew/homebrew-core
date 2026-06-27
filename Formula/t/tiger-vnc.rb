class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "https://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "b107c0c8b8a962594281690366c24186e95c2ea4a169acbc0076aa62ed01f467"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8d12a23c7b45cb2e6e0378d10e8eb6204e53e122c12c242c8980e942ac4f0281"
    sha256 cellar: :any, arm64_sequoia: "e7f98cddf036ea8f48b3201b7cdd2865e5c31650ce2b42e350d54005cf255e7f"
    sha256 cellar: :any, arm64_sonoma:  "a939e8096df31cc5bb02489ca4ad161d69f1cc5557dbbef82a9fb43cc173cdcb"
    sha256 cellar: :any, sonoma:        "62bb1dc72ab89cd10ae5b6b54c36cfb888b7e4a2fbc28cc2930edc276c294e09"
    sha256               arm64_linux:   "3986dbe4aa17163342747900c597a676b2b30a63cda679cf0b9d519c3d1dd636"
    sha256               x86_64_linux:  "c17bcd2d90aa9083be69775a866a6be8f68f66548cd181399f1a37fc4d2cf49f"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "fltk@1.3" # fltk 1.4 issue: https://github.com/TigerVNC/tigervnc/issues/1949
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "jpeg-turbo"
  depends_on "nettle"
  depends_on "pixman"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxdamage"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxft"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxtst"
    depends_on "linux-pam"
    depends_on "zlib-ng-compat"
  end

  # Apply Arch Linux patch to support Nettle 4. Remove in release with
  # https://github.com/TigerVNC/tigervnc/commit/be6e25fca026ce715d5be1d7ba40ef49bebbde51
  patch do
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/tigervnc/-/raw/3acb330ccb03832085c20b0f1bedec665c9a886f/nettle-4.patch"
    sha256 "5d290368a537a0d354773a06c096c1c1b36fd2de4d03860a5d82456f0b527a9b"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/vncviewer -h 2>&1", 1)
    assert_match(/TigerVNC v#{version}/, output)
  end
end
