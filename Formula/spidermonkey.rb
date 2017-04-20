class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://developer.mozilla.org/en/SpiderMonkey"
  url "https://archive.mozilla.org/pub/mozilla.org/js/js185-1.0.0.tar.gz"
  version "1.8.5"
  sha256 "5d12f7e1f5b4a99436685d97b9b7b75f094d33580227aa998c406bbae6f2a687"
  revision 2

  head "https://hg.mozilla.org/mozilla-central", :using => :hg

  bottle do
    cellar :any
    sha256 "62193341691f6f35a1d844409c587b431aa7540b70c02d90451e2cb3623788de" => :sierra
    sha256 "5e7789a8ba4e3259364bd3ae827037ba83bf3a076633799bf8f5869b885db399" => :el_capitan
    sha256 "38d1b7f54b5dbdd4a0e28e3a1077aed2ada42a9266cfaddeda6a08d761a2d8b2" => :yosemite
  end

  depends_on "readline"
  depends_on "nspr"

  conflicts_with "narwhal", :because => "both install a js binary"

  def install
    cd "js/src" do
      # Remove the broken *(for anyone but FF) install_name
      inreplace "config/rules.mk",
        "-install_name @executable_path/$(SHARED_LIBRARY) ",
        "-install_name #{lib}/$(SHARED_LIBRARY) "
    end

    mkdir "brew-build" do
      system "../js/src/configure", "--prefix=#{prefix}",
                                    "--enable-readline",
                                    "--enable-threadsafe",
                                    "--with-system-nspr",
                                    "--with-nspr-prefix=#{Formula["nspr"].opt_prefix}",
                                    "--enable-macos-target=#{MacOS.version}"

      inreplace "js-config", /JS_CONFIG_LIBS=.*?$/, "JS_CONFIG_LIBS=''"
      # These need to be in separate steps.
      system "make"
      system "make", "install"

      # Also install js REPL.
      bin.install "shell/js"
    end
  end

  test do
    path = testpath/"test.js"
    path.write "print('hello');"
    assert_equal "hello", shell_output("#{bin}/js #{path}").strip
  end
end
