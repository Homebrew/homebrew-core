class Iowow < Formula
  desc "The skiplist based persistent key/value storage engine"
  homepage "http://iowow.io"
  url "https://github.com/Softmotions/iowow/archive/v1.2.8.tar.gz"
  sha256 "bee46c7ef8262da26713f6fdf1a0d6d7dfd176aa55cf9efff18976f9be1e588a"
  head "https://github.com/Softmotions/iowow.git"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <iowow/iwkv.h>
      #include <string.h>
      #include <stdlib.h>

      int main() {
        IWKV_OPTS opts = {
          .path = "example1.db",
          .oflags = IWKV_TRUNC
        };
        IWKV iwkv;
        IWDB mydb;
        iwrc rc = iwkv_open(&opts, &iwkv);
        if (rc) {
          iwlog_ecode_error3(rc);
          return 1;
        }
        rc = iwkv_db(iwkv, 1, 0, &mydb);
        if (rc) {
          iwlog_ecode_error2(rc, "Failed to open mydb");
          return 1;
        }
        IWKV_val key, val;
        key.data = "foo";
        key.size = strlen(key.data);
        val.data = "bar";
        val.size = strlen(val.data);

        fprintf(stdout, "put: %.*s => %.*s\\n",
                (int) key.size, (char *) key.data,
                (int) val.size, (char *) val.data);

        rc = iwkv_put(mydb, &key, &val, 0);
        if (rc) {
          iwlog_ecode_error3(rc);
          return rc;
        }
        val.data = 0;
        val.size = 0;
        rc = iwkv_get(mydb, &key, &val);
        if (rc) {
          iwlog_ecode_error3(rc);
          return rc;
        }
        fprintf(stdout, "get: %.*s => %.*s\\n",
                (int) key.size, (char *) key.data,
                (int) val.size, (char *) val.data);
        iwkv_val_dispose(&val);
        iwkv_close(&iwkv);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-liowow", "-o", testpath/"test"
    system "./test"
  end
end
