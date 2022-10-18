class Tracker < Formula
  desc "Library and daemon that is an efficient search engine and triplestore"
  homepage "https://gnome.pages.gitlab.gnome.org/tracker/"
  url "https://download.gnome.org/sources/tracker/3.4/tracker-3.4.0.tar.xz"
  sha256 "b3b380c9571d7c7423b5f401e4a2f2d78de47143b035eb2c1281e2423c59218b"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  # Tracker doesn't follow GNOME's "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/tracker[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "fa292ce5ea663a2b22fe7754528afbc1064cf9478c59647c8c709ffaed97a9f9"
    sha256 arm64_big_sur:  "696b5885e4d6521fcbe595c06d4f8504aed04969beec74fa29f44eaf019c62fe"
    sha256 monterey:       "94a40857320c11adea0abfb0c86f5098bf20003e5dded988886837f43aea60a0"
    sha256 big_sur:        "ca8592edacf810ee016119cbc3bb60c6879e8fd2f2b0e2a5f29fa54daa8dd043"
    sha256 catalina:       "1ecf230ec1758bde96ea6569a9dc39e656199061cbe36fdc90fc0b77052f84f4"
    sha256 x86_64_linux:   "064ef519438d1a4e668d5540d1fe85ae7bd8c21874e86cf8b290ffb70f690d22"
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
