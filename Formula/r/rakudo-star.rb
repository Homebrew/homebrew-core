class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2025.12/rakudo-star-2025.12.tar.gz"
  sha256 "4dbfa9b39a704b5a3526a335444e0bf9e5a12a8a390ef33f8753a2b2c3a031e8"
  license "Artistic-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "51305175e473f0cf6c94f22da5833c252b04a2a252da91afc5398707156eb873"
    sha256 arm64_sequoia: "6050dffa40fb9cf5f02b3b455aa89eedd09390658d889445b696ff48086df363"
    sha256 arm64_sonoma:  "35eda1764a976ae1edecfc045a045ff4e40dd5e456a8334ebbc73455313c646f"
    sha256 sonoma:        "32ffe16f63d82a1facfbc98a47b6a34250157fcaf8c653bd02c269db0f40ab76"
    sha256 arm64_linux:   "ba8bf557b672dd2ed2b3b0f93bc2f2279c7f6c092d1dc972400b06df10f3a83f"
    sha256 x86_64_linux:  "dae805ddac85ce4b335457e5868ff7bd5ebbcf270b79653b5d39d78c0712b522"
  end

  depends_on "bash" => :build
  depends_on "pkgconf" => :build
  depends_on "sqlite" => [:build, :test]
  depends_on "libtommath"
  depends_on "mimalloc"
  depends_on "openssl@3" # for OpenSSL module, loaded by path
  depends_on "readline" # for Readline module, loaded by path
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "libuv"
  end

  conflicts_with "moor", because: "both install `moar` binaries"
  conflicts_with "moarvm", "nqp", because: "rakudo-star currently ships with moarvm and nqp included"
  conflicts_with "parrot"
  conflicts_with "rakudo"

  skip_clean "share/perl6/vendor/short"

  # 1. Allow adding arguments via inreplace to unbundle libraries in MoarVM
  # 2. Fix build with a system provided libuv
  # PR Ref: https://github.com/MoarVM/MoarVM/pull/1981
  patch :DATA

  def install
    # Unbundle libraries in MoarVM
    moarvm_3rdparty = buildpath.glob("src/moarvm-*/MoarVM-*/3rdparty").first
    %w[dyncall libatomicops libtommath mimalloc].each { |dir| rm_r(moarvm_3rdparty/dir) }
    moarvm_configure_args = %W[
      --c11-atomics
      --has-libffi
      --has-libtommath
      --has-mimalloc
      --pkgconfig=#{Formula["pkgconf"].opt_bin}/pkgconf
    ]
    # FIXME: brew `libuv` causes runtime failures on Linux, e.g.
    # "Cannot find method 'made' on object of type NQPMu"
    if OS.mac?
      moarvm_configure_args << "--has-libuv"
      rm_r(moarvm_3rdparty/"libuv")
    end
    inreplace "lib/actions/install.bash", "@@MOARVM_CONFIGURE_ARGS@@", moarvm_configure_args.join(" ")

    # Help Readline module find brew `readline` on Linux
    inreplace "src/rakudo-star-modules/Readline/lib/Readline.pm",
              %r{\((\n *)('/lib/x86_64-linux-gnu',)},
              "(\\1'#{Formula["readline"].opt_lib}',\\1\\2"

    ENV.deparallelize # An intermittent race condition causes random build failures.

    # make install runs tests that can hang on sierra
    # set this variable to skip those tests
    ENV["NO_NETWORK_TESTING"] = "1"

    # Help DBIish module find sqlite shared library
    ENV["DBIISH_SQLITE_LIB"] = Formula["sqlite"].opt_lib/shared_library("libsqlite3")

    # openssl module's brew --prefix openssl probe fails so set value here
    ENV["OPENSSL_PREFIX"] = Formula["openssl@3"].opt_prefix

    rm buildpath.glob("src/rakudo-star-modules/**/*.o")
    system "bin/rstar", "install", "-p", prefix.to_s

    #  Installed scripts are now in share/perl/{site|vendor}/bin, so we need to symlink it too.
    bin.install_symlink (share/"perl6/vendor/bin").children.select(&:executable?)
    bin.install_symlink (share/"perl6/site/bin").children.select(&:executable?)
  end

  test do
    out = shell_output("#{bin}/raku -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'")
    assert_equal "0123456789", out

    # Test OpenSSL module
    (testpath/"openssl.raku").write <<~PERL
      use OpenSSL::CryptTools;
      my $ciphertext = encrypt("brew".encode, :aes256, :iv(("0" x 16).encode), :key(('x' x 32).encode));
      print decrypt($ciphertext, :aes256, :iv(("0" x 16).encode), :key(('x' x 32).encode)).decode;
    PERL
    assert_equal "brew", shell_output("#{bin}/raku openssl.raku")

    # Test Readline module
    (testpath/"readline.raku").write <<~PERL
      use Readline;
      my $response = Readline.new.readline("test> ");
      print "[$response]";
    PERL
    assert_equal "test> brew\n[brew]", pipe_output("#{bin}/raku readline.raku", "brew\n", 0)

    # Test DBIish module
    (testpath/"sqlite.raku").write <<~PERL
      use DBIish;
      my $dbh = DBIish.connect("SQLite", :database<test.sqlite3>, :RaiseError);
      $dbh.execute("create table students (name text, age integer)");
      $dbh.execute("insert into students (name, age) values ('Bob', 14)");
      $dbh.execute("insert into students (name, age) values ('Sue', 12)");
      say $dbh.execute("select name from students order by age asc").allrows();
      $dbh.dispose;
    PERL
    assert_equal "([Sue] [Bob])\n", shell_output("#{bin}/raku sqlite.raku")
  end
end

__END__
--- a/lib/actions/install.bash
+++ b/lib/actions/install.bash
@@ -168,7 +168,7 @@ build_moarvm() {
 	fi
 
 	{
-		perl Configure.pl "$@" \
+		perl Configure.pl @@MOARVM_CONFIGURE_ARGS@@ "$@" \
 		&& make \
 		&& make install \
 		> "$logfile" \

diff --git a/src/moarvm-2025.12/MoarVM-2025.12/src/io/procops.c b/src/moarvm-2025.12/MoarVM-2025.12/src/io/procops.c
index de8dd90b41d7c36b306ddee714b4acfc50854640..71d04d20f7eb98ecd3342c34f534869b202faaa9 100644
--- a/src/moarvm-2025.12/MoarVM-2025.12/src/io/procops.c
+++ b/src/moarvm-2025.12/MoarVM-2025.12/src/io/procops.c
@@ -773,13 +773,17 @@ static MVMint64 get_pipe_fd(MVMThreadContext *tc, uv_pipe_t *pipe) {
         return 0;
 }
 static void spawn_setup(MVMThreadContext *tc, uv_loop_t *loop, MVMObject *async_task, void *data) {
-    MVMint64 spawn_result;
+    MVMint64 spawn_result = 0;
     char *error_str = NULL;
 
     /* Process info setup. */
     uv_process_t *process = MVM_calloc(1, sizeof(uv_process_t));
+#ifdef MVM_HAS_LIBUV_PTY
     uv_process_options2_t process_options = {0};
     process_options.version = UV_PROCESS_OPTIONS_VERSION;
+#else
+    uv_process_options_t process_options = {0};
+#endif
     uv_stdio_container_t process_stdio[3];
 
 #ifdef MVM_DO_PTY_OURSELF
@@ -804,13 +808,13 @@ static void spawn_setup(MVMThreadContext *tc, uv_loop_t *loop, MVMObject *async_
         goto spawn_setup_error;
 #endif
 
-        process_options.pty_cols =
+        int cols =
             MVM_repr_exists_key(tc, si->callbacks, tc->instance->str_consts.pty_cols)
             ? MVM_repr_get_int(tc, MVM_repr_at_key_o(tc,
                                                      si->callbacks,
                                                      tc->instance->str_consts.pty_cols))
             : 80;
-        process_options.pty_rows =
+        int rows =
             MVM_repr_exists_key(tc, si->callbacks, tc->instance->str_consts.pty_rows)
             ? MVM_repr_get_int(tc, MVM_repr_at_key_o(tc,
                                                      si->callbacks,
@@ -818,6 +822,9 @@ static void spawn_setup(MVMThreadContext *tc, uv_loop_t *loop, MVMObject *async_
             : 24;
 
 #ifdef MVM_HAS_LIBUV_PTY
+
+        process_options.pty_cols = cols;
+        process_options.pty_rows = rows;
         uv_pipe_t *pipe = MVM_malloc(sizeof(uv_pipe_t));
         uv_pipe_init(loop, pipe, 0);
         pipe->data = si;
@@ -995,7 +1002,11 @@ static void spawn_setup(MVMThreadContext *tc, uv_loop_t *loop, MVMObject *async_
 
     /* Attach data, spawn, report any error. */
     process->data = si;
+#ifdef MVM_HAS_LIBUV_PTY
     spawn_result  = uv_spawn2(loop, process, &process_options);
+#else
+    spawn_result  = uv_spawn(loop, process, &process_options);
+#endif
 
 #ifdef MVM_DO_PTY_OURSELF
     if (pty_mode)