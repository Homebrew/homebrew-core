class Tracker < Formula
  desc "Library and daemon that is an efficient search engine and triplestore"
  homepage "https://gnome.pages.gitlab.gnome.org/tracker/"
  # pull from git tag to get submodules
  url "https://gitlab.gnome.org/GNOME/tracker.git",
      tag:      "3.6.0",
      revision: "624ef729966f2d9cf748321bd7bac822489fa8ed"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1

  # Tracker doesn't follow GNOME's "even-numbered minor is stable" version
  # scheme but they do appear to use 90+ minor/patch versions, which may
  # indicate unstable versions (e.g., 1.99.0, 2.2.99.0, etc.).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:(?!\.9\d)\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "a786b2b3491a5703f792f0011716e5cb7ecee55928caffb765a2b6ac3f55cab3"
    sha256 arm64_ventura:  "277812e0fda3fd75fada5fe36ad2809755f35605ad2550988ea5a1634ffaad7c"
    sha256 arm64_monterey: "bc1401fea1e7c77ee3a1706c029aba7cde648b9228cfca990d1cd098f9e51bdb"
    sha256 sonoma:         "cf05c52e47410b399d2f52827d64027aa802009bee0db70a970a72009cfc5b2c"
    sha256 ventura:        "cdc13ce4c3b905226af7150eab017ad9eb08e3d894ed69e928b360cf218707c5"
    sha256 monterey:       "8a728aee6d68011f8bd3a071bb11edd3710996e45b8e1f2991d141f296ed1fe5"
    sha256 x86_64_linux:   "fd31fdf16061831cc0057d07f7dd89a7958c4895020fb7e4d9a058a984c2220a"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "pygobject3" => :build
  depends_on "vala" => :build

  depends_on "dbus"
  depends_on "glib"
  depends_on "icu4c"
  depends_on "json-glib"
  depends_on "libsoup"
  depends_on "sqlite"

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = std_meson_args + %w[
      -Dman=false
      -Ddocs=false
      -Dsystemd_user_services=false
      -Dtests=false
      -Dsoup=soup3
      --force-fallback-for=gvdb
    ]

    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libtracker-sparql/tracker-sparql.h>

      gint main(gint argc, gchar *argv[]) {
        g_autoptr(GError) error = NULL;
        g_autoptr(GFile) ontology;
        g_autoptr(TrackerSparqlConnection) connection;
        g_autoptr(TrackerSparqlCursor) cursor;
        int i = 0;

        ontology = tracker_sparql_get_ontology_nepomuk();
        connection = tracker_sparql_connection_new(0, NULL, ontology, NULL, &error);

        if (error) {
          g_critical("Error: %s", error->message);
          return 1;
        }

        cursor = tracker_sparql_connection_query(connection, "SELECT ?r { ?r a rdfs:Resource }", NULL, &error);

        if (error) {
          g_critical("Couldn't query: %s", error->message);
          return 1;
        }

        while (tracker_sparql_cursor_next(cursor, NULL, &error)) {
          if (error) {
            g_critical("Couldn't get next: %s", error->message);
            return 1;
          }
          if (i++ < 5) {
            if (i == 1) {
              g_print("Printing first 5 results:");
            }

            g_print("%s", tracker_sparql_cursor_get_string(cursor, 0, NULL));
          }
        }

        return 0;
      }
    EOS

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig" if OS.mac?
    flags = shell_output("pkg-config --cflags --libs tracker-sparql-3.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
