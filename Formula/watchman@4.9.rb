class WatchmanAT49 < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v4.9.0.tar.gz"
  sha256 "1f6402dc70b1d056fffc3748f2fdcecff730d8843bb6936de395b3443ce05322"
  license "MIT"

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "autoconf@2.69" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcre" => :recommended

  # To reduce building time
  uses_from_macos "python" => :build
  uses_from_macos "ruby" => [:build, :optional]

  option "without-python", "Disable python bindings"
  option "with-ruby", "Enable ruby bindings (requires ruby, gem, bundler)"
  option "without-pcre", "Don't enable PCRE support"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-statedir=#{var}/run/watchman
    ]

    args << "--enable-conffile=#{etc}/watchman.json" if OS.mac?
    args << "--without-pcre" if build.without? "pcre"
    args << "--without-python" if build.without? "python"

    # Fix for Ruby building
    if build.with? "ruby"
      args << "--with-ruby"

      inreplace "ruby/ruby-watchman/ruby-watchman.gemspec" do |s|
        s.gsub!(/'rake'$/, "'rake', '< 11.0'")
        s.gsub! "bundler', '~> 1", "bundler', '>= 1"
      end

      ENV["BUNDLE_PATH"] = "vendor/bundle"
    end

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      If you have any problem when building with Python and/or Ruby,
      please make links to executable `python` and `bundle` files in
      bin path of any dependent package, like:
        ln -s /**/Python.framework/Versions/*/bin/python3 #{Formula["pkg-config"].opt_bin}/python
        ln -s /Library/Ruby/Gems/*/bin/bundle #{Formula["pkg-config"].opt_bin}/

      If you have problems when building with system Ruby on old MacOS,
      please correct paths of Ruby development headers in Xcode/CLT, like:
        sudo ln -s universal-darwin17 /**/MacOSX.sdk/**/include/ruby-*/universal-darwin16

      After installation, to use `watchman-make` and `watchman-wait` scripts,
      you need to activate the Python package `pywatchman`, like:
        sudo ln -s #{lib}/*/site-packages/pywatchman* /Library/Python/*/site-packages/
    EOS
  end

  test do
    assert_equal("#{version}.0", shell_output("#{bin}/watchman -v").chomp)
  end
end
