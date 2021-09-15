class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/mozilla.org/js/js185-1.0.0.tar.gz"
  version "1.8.5"
  sha256 "5d12f7e1f5b4a99436685d97b9b7b75f094d33580227aa998c406bbae6f2a687"
  license "MPL-1.1"
  revision 4
  head "https://hg.mozilla.org/mozilla-central", using: :hg

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox release versions.
  livecheck do
    url "https://www.mozilla.org/en-US/firefox/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/releasenotes/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, big_sur:  "2d684e4bc093674e45578d2cdf7905cdececf8661ec75fe3fd4b29ce7db5eeb4"
    sha256 cellar: :any, catalina: "aa2807a42c05e6611cf530b84ce8165e77344a7a9da4eaa0af01c4023b9a7479"
    sha256 cellar: :any, mojave:   "8c0b46bc04a7e95f99262969b22cc311ee1f7d83413af05865318743ccd96944"
  end

  depends_on :macos # Due to Python 2
  depends_on "nspr"
  depends_on "readline"

  conflicts_with "narwhal", because: "both install a js binary"

  def install
    cd "js/src" do
      # Remove the broken *(for anyone but FF) install_name
      inreplace "config/rules.mk",
        "-install_name @executable_path/$(SHARED_LIBRARY) ",
        "-install_name #{lib}/$(SHARED_LIBRARY) "

      # The ./configure script assumes that it can find readline
      # just as "-lreadline", but we want it to look in opt/readline/lib
      inreplace "configure", "-lreadline", "-L#{Formula["readline"].opt_lib} -lreadline"
    end

    # The ./configure script that comes with spidermonkey 1.8.5 makes some mistakes
    # with Xcode 12's default setting of -Werror,implicit-function-declaration
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

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
