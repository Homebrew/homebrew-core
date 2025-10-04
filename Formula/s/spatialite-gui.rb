class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite_gui/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-2.1.0-beta1.tar.gz"
  sha256 "ba48d96df18cebc3ff23f69797207ae1582cce62f4596b69bae300ca3c23db33"
  license "GPL-3.0-or-later"
  revision 12

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/"
    regex(/href=.*?spatialite[._-]gui[._-]v?(\d+(?:\.\d+)+(?:[._-]\w+\d*)?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6905028f8a5725ce128325dbe01e1d2b2a0e46de526a1d3409e5162e95a09133"
    sha256 cellar: :any,                 arm64_sequoia: "0729ab0ef78b34d21105dfa31efdb84466c3f1299a11cea3c039ff91725fa941"
    sha256 cellar: :any,                 arm64_sonoma:  "024efe736240e668fb049f06eb744ed03223ca08edbb59e00e67dc67d9db1a1e"
    sha256 cellar: :any,                 arm64_ventura: "9e2d9c4d64a8e60daa2420254efbf2495442d957ca58231ae474b4f927e396f0"
    sha256 cellar: :any,                 sonoma:        "fe1ceda3cf1e7cde15a38279c2c78c73366bcf44f7f764aaa16d4ddece1c90fa"
    sha256 cellar: :any,                 ventura:       "a384ed8c6464d25bdc0e308dec8e3fcafbe3a0ab3d2e051a393f827470a74452"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a6e1e70058432026f675c50dbdba7a5237357de31655d9fb0ba71d4cb86051e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2470cea3a02d2b41424b39e453d047412ecffda08a2aa73d8d10c68ccd9ff90f"
  end

  depends_on "pkgconf" => :build
  depends_on "freexl"
  depends_on "geos"
  depends_on "libpq"
  depends_on "librasterlite2"
  depends_on "librttopo"
  depends_on "libspatialite"
  depends_on "libtiff"
  depends_on "libxlsxwriter"
  depends_on "libxml2"
  depends_on "lz4"
  depends_on "minizip"
  depends_on "openjpeg"
  depends_on "proj"
  depends_on "sqlite"
  depends_on "virtualpg"
  depends_on "webp"
  depends_on "wxwidgets@3.2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    # Link flags for sqlite don't seem to get passed to make, which
    # causes builds to fatally error out on linking.
    # https://github.com/Homebrew/homebrew/issues/44003
    sqlite = Formula["sqlite"]
    ENV.prepend "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3"
    ENV.prepend "CFLAGS", "-I#{sqlite.opt_include}"

    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)*)?$/) }.to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"
    args = ["--with-wxconfig=#{wx_config}"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end
end
