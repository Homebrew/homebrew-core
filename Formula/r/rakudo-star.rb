class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2025.04/rakudo-star-2025.04.tar.gz"
  sha256 "9c9fcb04b6fae5b56acbe9e580b688334fd0213d1c0d92118b16a8b9da3e54c8"
  license "Artistic-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "7ad5078b0eda6ed1b75e1490552f10f3062bcaccf9a47ff43850d782db6e3cb1"
    sha256 arm64_sonoma:  "4003960795806760c80e1bb49d280001b5cd0e78f08b5ab98f40d39deee51546"
    sha256 arm64_ventura: "a32d2826b6478b74b4d881e325a7840a21f9f295837c874b650097ee55375dfe"
    sha256 sonoma:        "924d3c51706e3f5f5511b1309a2c7b620bf032946e8b4b1c046dd0924bd63a87"
    sha256 ventura:       "08bc3921336989f0448023d67d88902525451e9c9ad07628c27fcc80860c7832"
    sha256 arm64_linux:   "a73d20233fbe6ef7804dfe3177fa344e28ebb3a39f889b53800d51ac46d8e907"
    sha256 x86_64_linux:  "156596cad01fd776d037ea9439d9533b37b4f61ce98b1866aafab07c4577bd84"
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
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxml2"

  on_macos do
    depends_on "libuv"
  end

  conflicts_with "moar", because: "both install `moar` binaries"
  conflicts_with "moarvm", "nqp", because: "rakudo-star currently ships with moarvm and nqp included"
  conflicts_with "parrot"
  conflicts_with "rakudo"

  # Apply open Config::Parser::json PR to fix unittests run during install
  # Ref: https://github.com/arjancwidlak/p6-Config-Parser-json/pull/1
  patch do
    url "https://github.com/arjancwidlak/p6-Config-Parser-json/commit/ca1a355c95178034b08ff9ebd1516a2e9d5bc067.patch?full_index=1"
    sha256 "d13230dc7d8ec0b72c21bd17e99a62d959fb3559d483eb43ce6be7ded8a0492a"
    directory "src/rakudo-star-modules/Config-Parser-json"
  end

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

    system "bin/rstar", "install", "-p", prefix.to_s

    #  Installed scripts are now in share/perl/{site|vendor}/bin, so we need to symlink it too.
    bin.install_symlink (share/"perl6/vendor/bin").children
    bin.install_symlink (share/"perl6/site/bin").children
  end

  def post_install
    (share/"perl6/vendor/short").mkpath
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

    # Test LibXML module
    (testpath/"libxml.raku").write <<~PERL
      use LibXML::Document;
      my LibXML::Document $doc .=  parse: :string('<Hello/>');
      $doc.root.nodeValue = 'World!';
      print $doc<Hello>;
    PERL
    assert_equal "<Hello>World!</Hello>", shell_output("#{bin}/raku libxml.raku")

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

    # Test Config::Parser::json module
    (testpath/"test.json").write <<~JSON
      { "foo": { "bar": [0, 1] } }
    JSON
    (testpath/"parser.raku").write <<~PERL
      use Config;
      use Config::Parser::json;
      my $config = Config.new();
      $config.=read("test.json");
      print $config.get('foo.bar');
    PERL
    assert_equal "0 1", shell_output("#{bin}/raku parser.raku")
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
