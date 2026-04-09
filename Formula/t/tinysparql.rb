class Tinysparql < Formula
  desc "Low-footprint RDF triple store with SPARQL 1.1 interface"
  homepage "https://tinysparql.org/"
  url "https://download.gnome.org/sources/tinysparql/3.11/tinysparql-3.11.0.tar.xz"
  sha256 "011e758a53f31112a8c45700fd6039ae55617f0dac70119d9eddafc03cf68fe5"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.gnome.org/GNOME/tinysparql.git", branch: "main"

  # TinySPARQL doesn't follow GNOME's "even-numbered minor is stable" version
  # scheme but they do appear to use 90+ minor/patch versions, which may
  # indicate unstable versions (e.g., 1.99.0, 2.2.99.0, etc.).
  livecheck do
    url "https://download.gnome.org/sources/tinysparql/cache.json"
    regex(/tinysparql[._-]v?(\d+(?:(?!\.9\d)\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "de1f0fd87b3725ca75dd651f6b6cccdbade9a49b206f1993dbf5824d74b4f585"
    sha256 arm64_sequoia: "701428db04e01b79f081710b4ce37fcde5fbb04e3543fe0ec4da813fd7c7c3cc"
    sha256 arm64_sonoma:  "df83b90506db3849d55757dc6de409064c73bc44b5c725ff2ea2039a9f6f2973"
    sha256 sonoma:        "bc7f868620da17dd9e847b4f72172296a4a49903ec6ffe1da8453e06591efe9e"
    sha256 arm64_linux:   "fe643e5cadb33ac30d5b209e596861307d76b11e039a43c8e6e96a9d45f7b972"
    sha256 x86_64_linux:  "57708914141e8d9b89901d4e7877bb846459f03c44176d7849a06a6b7ca05a40"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "dbus"
  depends_on "glib"
  depends_on "icu4c@78"
  depends_on "json-glib"
  depends_on "libsoup"
  depends_on "sqlite"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  # TODO: Remove patches when fix is in a release.
  # https://gitlab.gnome.org/GNOME/tinysparql/-/merge_requests/808
  patch do
    url "https://gitlab.gnome.org/GNOME/tinysparql/-/commit/1219e5ff4c4ce3afcbc5161baa27ef54153b2a99.diff"
    sha256 "67f9780f4438906b55c7f295b5f7afde30faef0885f94209e6c52654ea5b75d6"
  end

  patch do
    url "https://gitlab.gnome.org/GNOME/tinysparql/-/commit/b139706196da17089dbd0b5ee0f8713d1d50264d.diff"
    sha256 "16ec2db418b424991fd0c45130ef328ff76d4f21a8e6dbab69bef439fc6d3ab0"
  end

  patch do
    url "https://gitlab.gnome.org/GNOME/tinysparql/-/commit/806771f99e42c0ee8c7d9b2f66f5d65241131ce8.diff"
    sha256 "23b7124ab989e416787d98727f40b291260f786622e4a9d414df403bea7e403d"
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
