class Tracker < Formula
  desc "Library and daemon that is an efficient search engine and triplestore"
  homepage "https://gnome.pages.gitlab.gnome.org/tracker/"
  url "https://download.gnome.org/sources/tracker/3.3/tracker-3.3.0.tar.xz"
  sha256 "0706f96fe7f95df42acec812c1de7b4593a0d648321ca83506a9d71e22417bda"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

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
  depends_on "pkg-config" => [:build, :test]
  depends_on "pygobject3" => :build
  depends_on "vala" => :build
  depends_on "dbus"
  depends_on "glib"
  depends_on "icu4c"
  depends_on "json-glib"
  depends_on "libsoup"
  depends_on "sqlite"

  uses_from_macos "libxml2"

  # Fix build error: tracker_init_remote: code should not be reached
  patch do
    url "https://gitlab.gnome.org/GNOME/tracker/-/commit/95291bf791ead1db062dfe0f0b4626393cb58338.diff"
    sha256 "c3485e0323fca437a95f1f0c6ce002da86781d01c27a429ed0a4f7e408a22f2f"
  end

  # Fix build error: Invalid GType function: 'tracker_endpoint_http_get_type'
  patch do
    url "https://gitlab.gnome.org/GNOME/tracker/-/commit/471f7fd87da2fea4aeebdddb3579e95a14208647.diff"
    sha256 "8a90b9c197a63f55a4d126afd2e9ccad230856ba5b9bdd5c2a6a861419e57ac5"
  end

  def install
    args = std_meson_args + %w[
      -Dman=false
      -Ddocs=false
      -Dsystemd_user_services=false
      -Dtests=false
      -Dsoup=soup3
    ]

    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", *args, ".."
      # Disable parallel build due to error: 'libtracker-sparql/tracker-sparql-enum-types.h' file not found
      system "ninja", "-v", "-j1"
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
