class Uthash < Formula
  desc "C macros for hash tables and more"
  homepage "https://troydhanson.github.io/uthash/"
  url "https://github.com/troydhanson/uthash/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "e10382ab75518bad8319eb922ad04f907cb20cccb451a3aa980c9d005e661acc"
  license "BSD-1-Clause"
  head "https://github.com/troydhanson/uthash.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7332f52405884ffd9db409700b607565d8afeca373d6954ef84f03ed5842ddbe"
  end

  def install
    include.install buildpath.glob("src/*.h")
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <stdio.h>
      #include <stdlib.h>
      #include <string.h>
      #include <uthash.h>

      struct my_struct {
        int id;
        char name[15];
        UT_hash_handle hh;
      };

      int main() {
        struct my_struct *users = NULL;
        struct my_struct *s, *p = NULL;
        int uid = 42;
        char name[] = "John Doe";

        HASH_FIND_INT(users, &uid, s);
        assert(s == NULL);

        s = (struct my_struct*)malloc(sizeof *s);
        s->id = uid;
        strcpy(s->name, name);
        HASH_ADD_INT(users, id, s);

        HASH_FIND_INT(users, &uid, p);
        assert(s == p);

        HASH_DEL(users, s);
        free(s);
        HASH_FIND_INT(users, &uid, s);
        assert(s == NULL);
        printf("ok");
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-o", "test"
    assert_equal "ok", shell_output("./test")
  end
end
