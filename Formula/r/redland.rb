class Redland < Formula
  desc "RDF Library"
  homepage "https://librdf.org/"
  url "https://download.librdf.org/source/redland-1.0.17.tar.gz"
  sha256 "de1847f7b59021c16bdc72abb4d8e2d9187cd6124d69156f3326dd34ee043681"
  license any_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later", "Apache-2.0"]
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?redland[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "7c7aab000c18d388d284b94060060bdc54990d6aaa29475f702b8c85d9031ecb"
    sha256 arm64_sequoia:  "16526f739bc4c35eb3524005689e270dd9ce0828e0934d9d57f9693338b7fcda"
    sha256 arm64_sonoma:   "4671a0bffac8906190119990c40dd6642a6f432ec02ce96c56456c5cb48c91ab"
    sha256 arm64_ventura:  "16c721b39acf16e65892930227303d74673ce56ddaf252ca867da9391de7bad3"
    sha256 arm64_monterey: "25dd020d5d83642dd83c56583dd742dc549fcc32efbec67958faeebed4e1a849"
    sha256 arm64_big_sur:  "f54c731eecd682be899b7b8b5ab3424db134a1a48fe7076f0113deedb9a7f057"
    sha256 sonoma:         "2c0269bd53d0f3dbd166a44ffb32ccdfb39c2a4408fe68b751e9b9e28b504810"
    sha256 ventura:        "2c9931ba94fa4e8c4cd3b1983fdf55afa01838c3e6556664126733a7743c1575"
    sha256 monterey:       "f0b6b4b55556c730bb0eb720bcca0d4efd9ede0b13e15f39758fe2a193ce4933"
    sha256 big_sur:        "60ddb8775dfdff43901aac1138929c688b07e744304e24e1cd3d6183000620bf"
    sha256 catalina:       "f30068d691ac2748619a288912235236e905f672b1f80a974e95425c5f102a10"
    sha256 arm64_linux:    "40dd4a3c37bd52eb17f97912ab8baaefd3164c84f57ec8d8be6200677af307c8"
    sha256 x86_64_linux:   "5439aed60715d12f7bce18e9292ce3301fc93b89cdb2eae2bd072a0a59a5fc6b"
  end

  depends_on "pkgconf" => :build
  depends_on "libtool"
  depends_on "raptor"
  depends_on "rasqal"
  depends_on "sqlite"
  depends_on "unixodbc"

  resource "bindings" do
    url "https://download.librdf.org/source/redland-bindings-1.0.17.1.tar.gz"
    sha256 "ff72b587ab55f09daf81799cb3f9d263708fad5df7a5458f0c28566a2563b7f5"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--with-bdb=no",
                          "--with-mysql=no",
                          "--with-sqlite=yes",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <redland.h>

      int main(int argc, char *argv[]) {
        librdf_world* world;
        librdf_storage* storage;
        librdf_model* model;
        librdf_statement *statement;

        world = librdf_new_world();
        librdf_world_open(world);
        storage = librdf_new_storage(world, "file", "file.rdf", NULL);
        model = librdf_new_model(world, storage, NULL);
        statement = librdf_new_statement_from_nodes(
          world,
          librdf_new_node_from_uri_string(world, (const unsigned char*) "https://example.org/"),
          librdf_new_node_from_uri_string(world, (const unsigned char*) "http://purl.org/dc/elements/1.1/title"),
          librdf_new_node_from_literal(world, (const unsigned char*) "Homebrew was here", NULL, 0)
        );

        librdf_model_add_statement(model, statement);
        librdf_free_statement(statement);
        librdf_free_model(model);
        librdf_free_storage(storage);
        librdf_free_world(world);

        return 0;
      }
    C

    (testpath/"file.rdf").write <<~EOS
      <?xml version="1.0"?>
      <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
          xmlns:dc="http://purl.org/dc/elements/1.1/">
        <rdf:Description rdf:about="https://example.org">
          <dc:title>Example Site</dc:title>
          <dc:creator>Internet Assigned Numbers Authority</dc:creator>
          <dc:description>
            This domain is for use in illustrative examples in documents.
            You may use this domain in literature without prior coordination or asking for permission.
          </dc:description>
        </rdf:Description>
      </rdf:RDF>
    EOS

    includes = %W[
      -I#{include}
      -I#{Formula["raptor"].opt_include}/raptor2
      -I#{Formula["rasqal"].opt_include}/rasqal
    ]

    libs = %W[
      -L#{lib}
      -L#{Formula["raptor"].opt_lib}
      -L#{Formula["rasqal"].opt_lib}
      -lrdf -lraptor2 -lrasqal
    ]

    system ENV.cc, *includes, "test.c", *libs, "-o", "test"
    system testpath/"test"

    expected = <<~EOS
      #{" " * 2}<rdf:Description rdf:about="https://example.org/">
      #{" " * 4}<ns0:title xmlns:ns0="http://purl.org/dc/elements/1.1/">Homebrew was here</ns0:title>
      #{" " * 2}</rdf:Description>
    EOS
    assert_match expected, (testpath/"file.rdf").read
  end
end
