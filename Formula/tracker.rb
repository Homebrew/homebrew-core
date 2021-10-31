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
    rebuild 1
    sha256 arm64_big_sur: "82ae29dda588ea5ada4ff491d3c8f1bf48e8c26045ccee50dcc1760b591c2ed5"
    sha256 monterey:      "a2c5115435a203f579b167e26f89b45b5cca4687a4ddce15b8f1110834d9b98c"
    sha256 big_sur:       "9ad0f16018c66088bf4e8e3a90223ed83c725028c0804669233cbada926b3072"
    sha256 catalina:      "7361eef0000031ab96819b884fa8a2adaf33f6f2c3d00001f33895a0c7640af6"
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
