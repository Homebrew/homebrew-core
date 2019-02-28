class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://developer.mozilla.org/en/SpiderMonkey"
  url "https://archive.mozilla.org/pub/mozilla.org/js/js185-1.0.0.tar.gz"
  version "1.8.5"
  sha256 "5d12f7e1f5b4a99436685d97b9b7b75f094d33580227aa998c406bbae6f2a687"
  revision 3
  head "https://hg.mozilla.org/mozilla-central", :using => :hg

  bottle do
    cellar :any
    sha256 "739fbe8aad9a04de987cdb95e2cabf30229a799f6de4c00a5cf6ce175e2e1390" => :mojave
    sha256 "6970c515131a108d7e4ce50e49e2623ca88def0fbe11ddec4a641ef7de7d1787" => :high_sierra
    sha256 "dbd3bdb0970f940628aacdb2e4db2984d3c4fdd1d6829a0b648db5a9b9229738" => :sierra
  end

  depends_on "nspr"
  depends_on "readline"

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
