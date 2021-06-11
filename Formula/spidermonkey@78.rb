class SpidermonkeyAT78 < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev/"
  # NOTE: fetch source from here: https://treeherder.mozilla.org/jobs?repo=mozilla-release
  # click on the first SM(pkg) link you see, then navigate to `Artifacts` sheet
  # download the `mozjs-<version>.tar.xz`
  url "https://firefox-ci-tc.services.mozilla.com/api/queue/v1/task/RPc3WnqfRfK_CQdBKL8N_g/runs/0/artifacts/public/build/mozjs-78.11.0.tar.bz2"
  sha256 "cb418f21cb02b0d08cb6244af10c89110b1412b8e382809f6bf66984aee5e462"
  license "MPL-1.1"

  keg_only :versioned_formula

  depends_on "autoconf@2.13" => :build
  depends_on "pkg-config"    => :build
  depends_on "python@3.9"    => :build
  depends_on "rust"          => :build
  depends_on arch: :x86_64

  depends_on "icu4c"
  depends_on "nspr"

  uses_from_macos "libedit"

  def install
    inreplace "build/moz.configure/toolchain.configure",
                "sdk_max_version = Version('10.15.4')",
                "sdk_max_version = Version('11.99')"

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
