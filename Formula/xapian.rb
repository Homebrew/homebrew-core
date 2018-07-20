class Xapian < Formula
  desc "C++ search engine library with many bindings"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.7/xapian-core-1.4.7.tar.xz"
  mirror "https://fossies.org/linux/www/xapian-core-1.4.7.tar.xz"
  sha256 "13f08a0b649c7afa804fa0e85678d693fd6069dd394c9b9e7d41973d74a3b5d3"

  bottle do
    cellar :any
    sha256 "493d5e07e78b7261294faa0f99e1253a8f64ca3737eb67c5d6e5e3f4fc53f05c" => :high_sierra
    sha256 "5627d0d379658b5ca26e336fe7962de40854b428f35e981a292171d9d02fba08" => :sierra
    sha256 "5ef920ea1270679aa665ecd76907e21409dacd0c081897805afdb685572e6a2d" => :el_capitan
  end

  option "with-java", "Java bindings"
  option "with-php", "PHP bindings"
  option "with-ruby", "Ruby bindings"

  deprecated_option "java" => "with-java"
  deprecated_option "php" => "with-php"
  deprecated_option "ruby" => "with-ruby"
  deprecated_option "with-python" => "with-python@2"

  depends_on "ruby" => :optional if MacOS.version <= :sierra
  depends_on "python@2" => :optional
  depends_on "sphinx-doc" => :build if build.with? "python@2"

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.7/xapian-bindings-1.4.7.tar.xz"
    sha256 "4519751376dc5b59893b812495e6004fd80eb4a10970829aede71a35264b4e6a"
  end

  def install
    build_binds = build.with?("ruby") || build.with?("python@2") || build.with?("java") || build.with?("php")

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

        if build.with? "python@2"
          # https://github.com/Homebrew/homebrew-core/issues/2422
          ENV.delete("PYTHONDONTWRITEBYTECODE")

          (lib/"python2.7/site-packages").mkpath
          ENV["PYTHON_LIB"] = lib/"python2.7/site-packages"

          ENV.append_path "PYTHONPATH",
                          Formula["sphinx-doc"].opt_libexec/"lib/python2.7/site-packages"
          ENV.append_path "PYTHONPATH",
                          Formula["sphinx-doc"].opt_libexec/"vendor/lib/python2.7/site-packages"

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
      <<~EOS
        You may need to add the Ruby bindings to your RUBYLIB from:
          #{HOMEBREW_PREFIX}/lib/ruby/site_ruby

      EOS
    end
  end

  test do
    system bin/"xapian-config", "--libs"
  end
end
