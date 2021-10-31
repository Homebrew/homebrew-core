class Tracker < Formula
  desc "Library and daemon that is an efficient search engine and triplestore"
  homepage "https://gnome.pages.gitlab.gnome.org/tracker/"
  url "https://download.gnome.org/sources/tracker/3.1/tracker-3.1.2.tar.xz"
  sha256 "da368962665d587bb2e4f164d75919a81dacb35c7d4cfae6f93a94c60f60ec8f"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 2

  # Tracker doesn't follow GNOME's "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/tracker[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "91f76976c6f234c9a9349b7fd3049a5004a5c557577e6e9c24aeba0e5818c3a3"
    sha256 arm64_big_sur:  "121d8f5ee8518474aa90f5fc7e02e88b2cb0b17ca5b94b181b3204eb761727fa"
    sha256 monterey:       "e1e4da63da95c45ce6b717d20e544f84104a7d42e3fb207dae41cab4eedf2cfa"
    sha256 big_sur:        "0d3e0b8be3a4422e04bd665ad59d566889d9cecd7237ef0ef7168b7c6c32a6f2"
    sha256 catalina:       "980958cbbf2d74eadde9cf0043934ed1a56698520d764bee24cf83691b41b4ca"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "dbus"
  depends_on "icu4c"
  depends_on "json-glib"
  depends_on "libsoup@2"

  def install
    args = std_meson_args + %w[
      -Dman=false
      -Ddocs=false
      -Dsystemd_user_services=false
    ]

    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libtracker-sparql/tracker-sparql.h>

      gint main(gint argc, gchar *argv[]) {
        g_autoptr(GError) error = NULL;
        g_autoptr(GFile) store, ontology;
        g_autoptr(TrackerSparqlConnection) connection;
        g_autoptr(TrackerSparqlCursor) cursor;
        int i = 0;

        ontology = tracker_sparql_get_ontology_nepomuk();
        connection = tracker_sparql_connection_new(0, store, ontology, NULL, &error);

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
    glib = Formula["glib"]
    flags = %W[
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/tracker-3.0
      -D_REENTRANT
      -L#{glib.opt_lib}
      -L#{lib}
      -ltracker-sparql-3.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
