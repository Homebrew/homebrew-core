class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://github.com/rakudo/star/releases/download/2025.05/rakudo-star-2025.05.tar.gz"
  sha256 "b5f6b5135599db0a18baf1ec660e78dddc8d8ca46d80576407bd5dcf70a4d574"
  license "Artistic-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "7a895bdf00ddf27ce11aa6efb3ab0bb6d75fca0a5434741504f663f647b1a906"
    sha256 arm64_sonoma:  "45729625f5031385c361cf6c4f90fc9666605428da1b04e1268bdaff3af20143"
    sha256 arm64_ventura: "55e28472b5488f597e09a23ea81f990d56f4e796879b261d4460be8374158907"
    sha256 sonoma:        "2cdeb1c478e4da7097659e9c5ddf405e0499638343b6d2392d798404c6b7f0fb"
    sha256 ventura:       "d48e786a4ee839ec4b3ac52169816f41bccb525ab0a70a9ea9ef3fa755c647ba"
    sha256 arm64_linux:   "dd91e8d891e1b584f9ee9954a0d7d8956d21da8052144a13c876c095b63ddb91"
    sha256 x86_64_linux:  "d29b7a6848a5fb3295166adc2b1fdbbc77c85bc5480048f644c79241431b51d9"
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
