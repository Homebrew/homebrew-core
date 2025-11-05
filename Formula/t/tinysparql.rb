class Tinysparql < Formula
  desc "Low-footprint RDF triple store with SPARQL 1.1 interface"
  homepage "https://tinysparql.org/"
  url "https://download.gnome.org/sources/tinysparql/3.10/tinysparql-3.10.1.tar.xz"
  sha256 "5a7f3e789db6671a550ed6280ed4f60a60bea77368da92be68dc7d8d7e230265"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1
  head "https://gitlab.gnome.org/GNOME/tinysparql.git", branch: "main"

  # TinySPARQL doesn't follow GNOME's "even-numbered minor is stable" version
  # scheme but they do appear to use 90+ minor/patch versions, which may
  # indicate unstable versions (e.g., 1.99.0, 2.2.99.0, etc.).
  livecheck do
    url "https://download.gnome.org/sources/tinysparql/cache.json"
    regex(/tinysparql[._-]v?(\d+(?:(?!\.9\d)\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "90a9d4e285934a23cfb38b4a8410f19f9b20e0086447f34d5489b953bf950253"
    sha256 arm64_sequoia: "1f73787281850f174147e4a66a4be08baa96539bb61debc4f464cae1ab45eabe"
    sha256 arm64_sonoma:  "236421dcbf8307292b06b0a8599a1a694d1cd4ac4faad453e0f53190a59e15fa"
    sha256 sonoma:        "40eb8fa83ed0f88fabb44b05e68dec6ed7b79719929cab94e2037f40f1dab09c"
    sha256 arm64_linux:   "41dee40c34bf2f0c6556060937d92f8eca469425a82707d098eeefea9a88b011"
    sha256 x86_64_linux:  "d06043b1ac9cd894653d4ea399765da704dc8ba2e7768405b9f0ce9bea75dc47"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "dbus"
  depends_on "glib"
  depends_on "icu4c@77"
  depends_on "json-glib"
  depends_on "libsoup"
  depends_on "sqlite"

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
    ]

    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
