class Tracker < Formula
  desc "Library and daemon that is an efficient search engine and triplestore"
  homepage "https://gnome.pages.gitlab.gnome.org/tracker/"
  # pull from git tag to get submodules
  url "https://gitlab.gnome.org/GNOME/tracker.git",
      tag:      "3.6.0",
      revision: "624ef729966f2d9cf748321bd7bac822489fa8ed"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 2

  # Tracker doesn't follow GNOME's "even-numbered minor is stable" version
  # scheme but they do appear to use 90+ minor/patch versions, which may
  # indicate unstable versions (e.g., 1.99.0, 2.2.99.0, etc.).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:(?!\.9\d)\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "572ce6780679b9aa84e7ff00ea91e547660870e37290068f74e4ec88ca4a9ccd"
    sha256 arm64_sonoma:  "eba5a267f049004c51f5f1b8e0969ffe59c7ea7914a9e6abb313425b62247077"
    sha256 arm64_ventura: "90aca5813f89aa0564cd8f6b1519f9f060b8d5f8cbbbd8f3143f668d0eabf7d4"
    sha256 sonoma:        "c035256e46520521dfc50ee2d67c6b255b82f4905f11b9a0d9fda4178424dd9d"
    sha256 ventura:       "2969610e34a1a51e2d9d8d5c18ab117b0683e6c9285772cea0ac280fec3ba455"
    sha256 x86_64_linux:  "4390b2647d6d14888e0467bc31d7a97f1a77997c0bc86d1d61ead40aca7eb17c"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "pygobject3" => :build
  depends_on "vala" => :build

  depends_on "dbus"
  depends_on "glib"
  depends_on "icu4c@75"
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

    icu4c = deps.map(&:to_formula).find { |f| f.name.match?(/^icu4c@\d+$/) }
    ENV.prepend_path "PKG_CONFIG_PATH", icu4c.opt_lib/"pkgconfig"
    flags = shell_output("pkg-config --cflags --libs tracker-sparql-3.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
