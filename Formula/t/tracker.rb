class Tracker < Formula
  desc "Library and daemon that is an efficient search engine and triplestore"
  homepage "https://gitlab.gnome.org/GNOME/tinysparql"
  # pull from git tag to get submodules
  url "https://gitlab.gnome.org/GNOME/tinysparql.git",
      tag:      "3.6.0",
      revision: "624ef729966f2d9cf748321bd7bac822489fa8ed"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 4

  bottle do
    sha256 arm64_sequoia: "34218a3697312858347f19f7b687ad25626b65dd8f78c10efd462df9327eb078"
    sha256 arm64_sonoma:  "cb0d4881cc33a9e7a2d68c2c02f1011840ed28a4a1c3333bad6d4a254861a3e7"
    sha256 arm64_ventura: "3d7d3a10c25bbc2c3161945c5eee127b3b6a0adb40db702cd5a13bed35602ec4"
    sha256 sonoma:        "5d7a0c796901eb167fb888acabff2a609ecf161dba2e8bf8df1066e9a7360cf3"
    sha256 ventura:       "d2f1ea7776a2aeb58a5c9adafe33bfa75c405cbd47059c6c8b86700118006514"
    sha256 arm64_linux:   "cfb05bf573cc5509b0013ffb1360318797dda5aeb9bb978d5c56bdf092b3d3f0"
    sha256 x86_64_linux:  "11ce63277d3d02cf375c31b84744a10cccac59b65b8227c8c7f08c9dbe377528"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "pygobject3" => :build
  depends_on "vala" => :build

  depends_on "dbus"
  depends_on "glib"
  depends_on "icu4c@77"
  depends_on "json-glib"
  depends_on "libsoup"
  depends_on "sqlite"

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "libxml2"

  on_macos do
    deprecate! date: "2025-01-18", because: "does not build on macOS for recent releases (3.7.0+)"
    depends_on "gettext"
  end

  on_linux do
    deprecate! date:                "2025-01-18",
               because:             "was renamed but we cannot formula rename due to macOS build failure",
               replacement_formula: "tinysparql"
  end

  conflicts_with "tinysparql", because: "both install the same libraries"

  def install
    args = %w[
      -Dman=false
      -Ddocs=false
      -Dsystemd_user_services=false
      -Dtests=false
      -Dsoup=soup3
      --force-fallback-for=gvdb
    ]

    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    icu4c = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                .to_formula
    ENV.prepend_path "PKG_CONFIG_PATH", icu4c.opt_lib/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs tracker-sparql-3.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
