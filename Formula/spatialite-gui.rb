class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite_gui/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-1.7.1.tar.gz"
  sha256 "cb9cb1ede7f83a5fc5f52c83437e556ab9cb54d6ace3c545d31b317fd36f05e4"
  license "GPL-3.0-or-later"
  revision 9

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/"
    regex(/href=.*?spatialite[._-]gui[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6de2a39b031d8ba0cd2d7c7653ecf59f348d8e32e479a430b21dc7c77c5eb0bb"
    sha256 cellar: :any,                 arm64_big_sur:  "1798e180ff29ec05b186eaae415e7277ec7d1779b0a97cf06b5c311102e0c35b"
    sha256 cellar: :any,                 monterey:       "e888e303a9f44a71d778de8fc99e6c18f3a8629310e0f99ee5db9f7529e581ad"
    sha256 cellar: :any,                 big_sur:        "04e3fce9bfefa6945a34adef96ccacd6c66bcaad8a1607bc9de447677580bda8"
    sha256 cellar: :any,                 catalina:       "670a668e9560d58127746708338d809a59f4961af89f917affc60ba8c32633e9"
    sha256 cellar: :any,                 mojave:         "3a3678ffccb6de1b99a2bf2f1f4a0b918a854bbf39d415b6e6e1c6971274c8ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3ec2a26e83e966f207cc694dab91470d8215dcc650f50866f59ea20834a465c"
  end

  depends_on "pkg-config" => :build
  depends_on "freexl"
  depends_on "geos"
  depends_on "libgaiagraphics"
  depends_on "libspatialite"
  depends_on "proj@7"
  depends_on "sqlite"
  depends_on "wxwidgets@3.0"

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/spatialite-gui/1.7.1.patch"
    sha256 "37f71f3cb2b0b9649eb85a51296187b0adf2972c5a1d3ee0daf3082e2c35025e"
  end

  def install
    wxwidgets = Formula["wxwidgets@3.0"]
    ENV["WX_CONFIG"] = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"

    # Link flags for sqlite don't seem to get passed to make, which
    # causes builds to fatally error out on linking.
    # https://github.com/Homebrew/homebrew/issues/44003
    #
    # spatialite-gui uses `proj` (instead of `proj@7`) if installed
    sqlite = Formula["sqlite"]
    proj = Formula["proj@7"]
    ENV.prepend "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3 -L#{proj.opt_lib}"
    ENV.prepend "CFLAGS", "-I#{sqlite.opt_include} -I#{proj.opt_include}"

    # Use Proj 6.0.0 compatibility headers
    # https://www.gaia-gis.it/fossil/spatialite_gui/tktview?name=8349866db6
    ENV.append_to_cflags "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H"

    # Add aui library; reported upstream multiple times:
    # https://groups.google.com/forum/#!searchin/spatialite-users/aui/spatialite-users/wnkjK9pde2E/hVCpcndUP_wJ
    inreplace "configure" do |s|
      s.gsub! "WX_LIBS=\"$(wx-config --libs)\"", "WX_LIBS=\"$(wx-config --libs std,aui)\""
      # configure does not make proper use of `WX_CONFIG`
      s.gsub! "S=\"$(wx-config --", "S=\"$($WX_CONFIG --"
    end
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
