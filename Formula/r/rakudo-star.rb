class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2026.05/rakudo-star-2026.05.tar.gz"
  sha256 "d9fe36089a4915c3b3118b4fe7236bbc8226320d843c7814975a2b6677a46bce"
  license "Artistic-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "4ffe3877a9364546cfdbd9868efdfa851c9d82947d74451f7b159704c5ec56d3"
    sha256 arm64_sequoia: "d1f2eecb001a96a846dfd4237e4fdf9c7b2a17713fe0d2e941a17d9138850c20"
    sha256 arm64_sonoma:  "904ce902f0af04a72d6aae489d98f310cb8b6ab8dac637b4e80ba1d2f6b5bbd5"
    sha256 sonoma:        "a024faad8ee3bba073eec3ffab5fb80ba054af0ffda1211a6ddd76caef035efe"
    sha256 arm64_linux:   "21777449ba04c8138fc3eb2ee9131e2dc3907e489c8a7a72ff73b8cbddcc8475"
    sha256 x86_64_linux:  "7c8e8c4d84d64196d51c340d354bccaa7d83cb4fe701a84e5ebc0cc4c51d3123"
  end

  depends_on "pkgconf" => :build
  depends_on "sqlite" => [:build, :test]
  depends_on "libtommath"
  depends_on "mimalloc"
  depends_on "openssl@3" => :no_linkage # for OpenSSL module, loaded by path
  depends_on "readline" => :no_linkage # for Readline module, loaded by path
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "bash" => :build
    depends_on "libuv"
  end

  conflicts_with "moor", because: "both install `moar` binaries"
  conflicts_with "moarvm", "nqp", because: "rakudo-star currently ships with moarvm and nqp included"
  conflicts_with "parrot"
  conflicts_with "rakudo"

  skip_clean "share/perl6/vendor/short"

  # Allow adding arguments via inreplace to unbundle libraries in MoarVM
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
