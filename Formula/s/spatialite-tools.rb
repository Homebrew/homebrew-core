class SpatialiteTools < Formula
  desc "CLI tools supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite-tools/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-5.1.0.tar.gz"
  sha256 "df3030367c089ca90fa6630897f3f1a280784da29e1ba634f340dba4b08583b5"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/"
    regex(/href=.*?spatialite-tools[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a1096dff25f02e08e93d9f332765895404b255108324245eeab08cc1b0265c23"
    sha256 cellar: :any,                 arm64_sonoma:   "4bd025e06a9466bab7e2c623b67d793069852b860456c1b08e43b8c5365515f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ec7d078c58b3eef0e931c6f0bef1760eaf288501c2cb45efa78ab11f4934efa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "095be35895db6bfe29a616f878845db1798cde3d97d27c9ac26003f85ea5f589"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5641d6bb597c7cf039b33b9bd9b3d54f37659ce3aaa278f1fc211ea80efeb82"
    sha256 cellar: :any,                 sonoma:         "25a7d8b7bd24d839a25840dfb2251e05b6db76b7c34ead2914ccc77a245ee2c5"
    sha256 cellar: :any_skip_relocation, ventura:        "94eb1627d64ec557b504def0c18548fe159c84132dd85b2656764c11ff4b2758"
    sha256 cellar: :any_skip_relocation, monterey:       "8e59743367a535c343149b04d25f4abda572f34469516851c3e6b606db6fc7d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "73c977980d27f5a82f2cc7f21a843b9c2c9b912501d503998312756dd9ab9430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbf36de708f0b4ade1201cdf1e0878b08283c155fd486fb9d7ec8d856e3a2e78"
  end

  depends_on "pkg-config" => :build

  depends_on "libspatialite"
  depends_on "libxml2"
  depends_on "proj"
  depends_on "readline"
  depends_on "readosm"
  depends_on "sqlite"

  uses_from_macos "expat"

  on_macos do
    depends_on "freexl"
    depends_on "geos"
    depends_on "librttopo"
    depends_on "minizip"
  end

  def install
    # See: https://github.com/Homebrew/homebrew/issues/3328
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    # Ensure Homebrew SQLite is found before system SQLite.
    sqlite = Formula["sqlite"]
    ENV.prepend "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3"
    ENV.prepend "CFLAGS", "-I#{sqlite.opt_include}"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"spatialite", "--version"
  end
end
