class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey"
  url "https://archive.mozilla.org/pub/mozilla.org/js/js185-1.0.0.tar.gz"
  version "1.8.5"
  sha256 "5d12f7e1f5b4a99436685d97b9b7b75f094d33580227aa998c406bbae6f2a687"
  license "MPL-1.1"
  revision 4
  head "https://hg.mozilla.org/mozilla-central", using: :hg

  livecheck do
    url "https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey/Releases"
    regex(%r{href=.*?Releases/v?(\d+(?:\.\d+)*)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "f27ae227bcc2f755a89fb0e7075d7609fbebf0c442c5b558dde314ed477f2e8b" => :big_sur
    sha256 "876cb32f87f7f61b5d0b7b5b62fb5881cb859112eb8235304d75755add2b8af3" => :catalina
    sha256 "8cda55126be55fce01a82cf60e10522e211e7d8d384a0935c74a9d524256127f" => :mojave
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
