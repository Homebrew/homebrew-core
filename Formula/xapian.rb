class Xapian < Formula
  desc "C++ search engine library with many bindings"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.1/xapian-core-1.4.1.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/x/xapian-core/xapian-core_1.4.1.orig.tar.xz"
  sha256 "c5f2534de73c067ac19eed6d6bec65b7b2c1be00131c8867da9e1dfa8bce70eb"

  bottle do
    cellar :any
    sha256 "bd192a730135a58f8ce2ef10ebc6b666d1b69ba8963236873c817e8e5c4a4957" => :sierra
    sha256 "f365378f4940d20051d9aa51f2beb1bfafae95d728767f59e91ef50c92e34323" => :el_capitan
    sha256 "404fd689318016e6d8eb6b8011fa4dd195eff1bad73fd9bc72fb71ddf256d635" => :yosemite
  end

  option "with-java", "Java bindings"
  option "with-php", "PHP bindings"
  option "with-ruby", "Ruby bindings"

  deprecated_option "java" => "with-java"
  deprecated_option "php" => "with-php"
  deprecated_option "ruby" => "with-ruby"

  depends_on :ruby => ["2.1", :optional]
  depends_on :python => :optional
  depends_on "sphinx-doc" => :build if build.with?("python")

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.1/xapian-bindings-1.4.1.tar.xz"
    sha256 "6ca9731eed0fdfd84c6f8d788389bc7e7a7dc62fa46e0383eb0bb502576c2331"
  end

  def install
    build_binds = build.with?("ruby") || build.with?("python") || build.with?("java") || build.with?("php")

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    if build_binds
      resource("bindings").stage do
        ENV["XAPIAN_CONFIG"] = bin/"xapian-config"

        args = %W[
          --disable-dependency-tracking
          --prefix=#{prefix}
        ]

        args << "--with-java" if build.with? "java"

        if build.with? "ruby"
          ruby_site = lib/"ruby/site_ruby"
          ENV["RUBY_LIB"] = ENV["RUBY_LIB_ARCH"] = ruby_site
          args << "--with-ruby"
        end

        if build.with? "python"
          # https://github.com/xapian/xapian/pull/126
          inreplace "python/Makefile.in", "$(PYTHON2) $(SPHINX_BUILD)", "$(SPHINX_BUILD)"

          # https://github.com/Homebrew/homebrew-core/issues/2422
          ENV.delete("PYTHONDONTWRITEBYTECODE")

          (lib/"python2.7/site-packages").mkpath
          ENV["PYTHON_LIB"] = lib/"python2.7/site-packages"
          # configure looks for python2 and system python doesn't install one
          ENV["PYTHON"] = which "python"
          args << "--with-python"
        end

        if build.with? "php"
          extension_dir = lib/"php/extensions"
          extension_dir.mkpath
          args << "--with-php" << "PHP_EXTENSION_DIR=#{extension_dir}"
        end

        system "./configure", *args
        system "make", "install"
      end
    end
  end

  def caveats
    if build.with? "ruby"
      <<-EOS.undent
        You may need to add the Ruby bindings to your RUBYLIB from:
          #{HOMEBREW_PREFIX}/lib/ruby/site_ruby

      EOS
    end
  end

  test do
    system bin/"xapian-config", "--libs"
  end
end
