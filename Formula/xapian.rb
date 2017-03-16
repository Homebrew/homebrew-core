class Xapian < Formula
  desc "C++ search engine library with many bindings"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.3/xapian-core-1.4.3.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/x/xapian-core/xapian-core_1.4.3.orig.tar.xz"
  sha256 "7d5295511ca2de70463a29e75f6a2393df5dc1485bf33074b778c66e1721e475"

  bottle do
    cellar :any
    sha256 "91ae9de4f7db80f7cf815f16370d37df12c81afd76c23a4971afb7e77f7a0ca5" => :sierra
    sha256 "b42b9bf9109d678b357cafbfe828640f1472388c4997ae9a4c75220277ff0b29" => :el_capitan
    sha256 "b289c6973e8f7f98f2ee26c2c912df1e9d4ea2dedaa0b7ff6a1bcbc3b3c14cdd" => :yosemite
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
    url "https://oligarchy.co.uk/xapian/1.4.3/xapian-bindings-1.4.3.tar.xz"
    sha256 "65b5455bf81e4f39fda49a6ad99353b05889d11d7c4c2cae001a0a1e0dac0d87"
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
          # https://github.com/Homebrew/homebrew-core/issues/2422
          ENV.delete("PYTHONDONTWRITEBYTECODE")

          (lib/"python2.7/site-packages").mkpath
          ENV["PYTHON_LIB"] = lib/"python2.7/site-packages"

          # configure looks for python2 and system python doesn't install one
          ENV["PYTHON"] = which "python"

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
