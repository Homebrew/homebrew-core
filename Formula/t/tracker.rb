class Tracker < Formula
  desc "Library and daemon that is an efficient search engine and triplestore"
  homepage "https://gitlab.gnome.org/GNOME/tinysparql"
  # pull from git tag to get submodules
  url "https://gitlab.gnome.org/GNOME/tinysparql.git",
      tag:      "3.6.0",
      revision: "624ef729966f2d9cf748321bd7bac822489fa8ed"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 3

  # Tracker doesn't follow GNOME's "even-numbered minor is stable" version
  # scheme but they do appear to use 90+ minor/patch versions, which may
  # indicate unstable versions (e.g., 1.99.0, 2.2.99.0, etc.).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:(?!\.9\d)\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "7bc9ae43638dc877591fddf360e63423faca1c263a80eaec7016c56c526c7891"
    sha256 arm64_sonoma:  "97c7afc9f1177586a46d70761edd999dfb89db9e824750894dbc357dceb26a53"
    sha256 arm64_ventura: "49f5ca10fcc3bb45bb6c82a20b5c112fefd5e8c94b81e0f1abdbe1aa80b1810c"
    sha256 sonoma:        "85b6515fcef419b02070410794f79047fb646aa1fa12693d94b7a1b349f6cdda"
    sha256 ventura:       "17e2d6239703864d719f29322f28d0e17b588a99b3b40dead296242c4857642d"
    sha256 x86_64_linux:  "83e5feea79a2bc65e893cd9dd6cbc7204d30f9dd51f857ce49c6e02aa67ae89e"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "pygobject3" => :build
  depends_on "vala" => :build

  depends_on "dbus"
  depends_on "glib"
  depends_on "icu4c@76"
  depends_on "json-glib"
  depends_on "libsoup"
  depends_on "sqlite"

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

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
