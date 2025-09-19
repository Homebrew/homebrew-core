class Tpl < Formula
  desc "Store and retrieve binary data in C"
  homepage "https://troydhanson.github.io/tpl/"
  url "https://github.com/troydhanson/tpl/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "0b3750bf62f56be4c42f83c89d8449b24f1c5f1605a104801d70f2f3c06fb2ff"
  license "BSD-1-Clause"
  head "https://github.com/troydhanson/tpl.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "c308e47d85f79d24b666e56b5c980f7593ca25816e5e73b614964a224bf82466"
    sha256 cellar: :any,                 arm64_sequoia:  "563eee39c340a994167ebeaa62bba135164a2873031485754b3bd237e235a313"
    sha256 cellar: :any,                 arm64_sonoma:   "648d49fb0cd54c646e5257ba9aba1b88867913b5cb54e8accdbdf45dcd2b038d"
    sha256 cellar: :any,                 arm64_ventura:  "2bfb6b7bbdfecfa9aa8e25c3841dd9dbc6d333c746792a446ac729536c643475"
    sha256 cellar: :any,                 arm64_monterey: "cd423b01e4be55cc76cfc5c780582519f9583073f8b4e42a823c007cc59805e6"
    sha256 cellar: :any,                 arm64_big_sur:  "28d206fb0a8b3d318bbb8281a2cf64cb371f6a78896bc6c4b0b4187a2c109e96"
    sha256 cellar: :any,                 sonoma:         "76ba231b3d240b5a5302162c0ea2aa1bf0bf8d2ac4557f063495ab56bd584163"
    sha256 cellar: :any,                 ventura:        "b67d07d542d44a4fd9f2bb91e6f080796a264229eaffee4b19fad72295576db5"
    sha256 cellar: :any,                 monterey:       "0b544b3ee645924b61bd2a7f2b2d237e02796e26fd57be3688a900b050c7fb33"
    sha256 cellar: :any,                 big_sur:        "cdfa3d793f5b6086e7f50abdce45fd21bb869444dc202e285f8c486f18e9f1f8"
    sha256 cellar: :any,                 catalina:       "25b8a5fa1deda50c6dd07d69e96dd41e647b78b0f57f2696e5ddd056e509c71b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "649efbc4c4e6c8e57d4f7207bc2ede36facb438e7fd272162722f9707db999bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49c4f470d6782300dd24da0af8a3886cc977a9c24a0de37c606181b3db09e44d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    (testpath/"store.c").write <<~C
      #include <tpl.h>

      int main(int argc, char *argv[]) {
          tpl_node *tn;
          int id = 0;
          char *name, *names[] = { "Alice", "Bob", "Charlie" };

          tn = tpl_map("A(is)", &id, &name);

          for(name = names[0]; id < 3; name = names[++id]) {
              tpl_pack(tn,1);
          }

          tpl_dump(tn, TPL_FILE, "users.tpl");
          tpl_free(tn);
      }
    C

    (testpath/"load.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <tpl.h>

      int main(int argc, char *argv[]) {
          tpl_node *tn;
          int id;
          char *name;

          tn = tpl_map("A(is)", &id, &name);
          tpl_load(tn, TPL_FILE, "users.tpl");

          while (tpl_unpack(tn, 1) > 0) {
              printf("%d: %s\\n", id, name);
              free(name);
          }
          tpl_free(tn);
      }
    C

    system ENV.cc, "store.c", "-I#{include}", "-L#{lib}", "-ltpl", "-o", "store"
    system ENV.cc, "load.c", "-I#{include}", "-L#{lib}", "-ltpl", "-o", "load"

    expected = <<~EOS
      0: Alice
      1: Bob
      2: Charlie
    EOS

    system "./store"
    assert_equal expected, shell_output("./load")
  end
end
