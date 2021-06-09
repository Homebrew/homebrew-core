class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev/"
  # NOTE: fetch source from here: https://treeherder.mozilla.org/jobs?repo=mozilla-release
  # click on the first SM(pkg) link you see, then navigate to `Artifacts` sheet
  # download the `mozjs-<version>.tar.xz`
  url "https://firefox-ci-tc.services.mozilla.com/api/queue/v1/task/OrV4RM3WTS6k2O3xbrLj1A/runs/0/artifacts/public/build/mozjs-89.0.0.tar.xz"
  sha256 "50b930324d9e399279002ca90233d9555d67dba3a5f005d83539caee38adb252"
  license "MPL-1.1"
  head "https://hg.mozilla.org/mozilla-central", using: :hg

  livecheck do
    url "https://ftp.mozilla.org/pub/firefox/releases/"
    regex(/(\d+(?:\.\d+)+)/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, big_sur:  "2d684e4bc093674e45578d2cdf7905cdececf8661ec75fe3fd4b29ce7db5eeb4"
    sha256 cellar: :any, catalina: "aa2807a42c05e6611cf530b84ce8165e77344a7a9da4eaa0af01c4023b9a7479"
    sha256 cellar: :any, mojave:   "8c0b46bc04a7e95f99262969b22cc311ee1f7d83413af05865318743ccd96944"
  end

  depends_on "autoconf@2.13" => :build
  depends_on "pkg-config"    => :build
  depends_on "python@3.9"    => :build
  depends_on "rust"          => :build

  depends_on "icu4c"
  depends_on "nspr"

  uses_from_macos "libedit"

  def install
    # TODO: remove this `inreplace` statement in future because
    # upstream has removed the `sdk_max_version`
    inreplace "build/moz.configure/toolchain.configure",
                'sdk_max_version = Version("11.1")',
                'sdk_max_version = Version("11.99")'

    inreplace "config/rules.mk",
              "-install_name $(_LOADER_PATH)/$(SHARED_LIBRARY) ",
              "-install_name #{lib}/$(SHARED_LIBRARY) "

    args = %W[
      --prefix=#{prefix}
      --enable-optimize
      --enable-readline
      --enable-release
      --enable-shared-js
      --disable-jemalloc
      --with-intl-api
      --with-system-icu
      --with-system-nspr
      --with-system-zlib
    ]

    cd "js/src"
    mkdir "brew_build" do
      system "../configure", *args
      system "make"
      system "make", "install"
      rm lib/"libjs_static.ajs"
    end
  end

  test do
    path = testpath/"test.js"
    path.write "print('hello');"
    assert_equal "hello", shell_output("#{bin}/js#{version.major} #{path}").strip
  end
end
