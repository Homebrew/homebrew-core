class Xapian < Formula
  desc "C++ search engine library with many bindings"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.5/xapian-core-1.4.5.tar.xz"
  mirror "https://fossies.org/linux/www/xapian-core-1.4.5.tar.xz"
  sha256 "85b5f952de9df925fd13e00f6e82484162fd506d38745613a50b0a2064c6b02b"

  bottle do
    cellar :any
    sha256 "091e71844cbd10c6d47e1a3bd7bc6eafc6868d01c73f7bc80ec0c5c89b3953e5" => :high_sierra
    sha256 "0575873ed3b9ccd8193e8d643541e68b84b4cc258c8a62bb28a6dd62188adb1e" => :sierra
    sha256 "2fdf665d79e63dc34597f64d457326af35154e37bb4e24db6dd030a8973fbf8e" => :el_capitan
  end

  option "with-java", "Java bindings"
  option "with-php", "PHP bindings"
  option "with-ruby", "Ruby bindings"

  deprecated_option "java" => "with-java"
  deprecated_option "php" => "with-php"
  deprecated_option "ruby" => "with-ruby"

  depends_on "ruby" => :optional if MacOS.version <= :sierra
  depends_on "python" => :optional
  depends_on "sphinx-doc" => :build if build.with?("python")

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.5/xapian-bindings-1.4.5.tar.xz"
    sha256 "647886730a71bcc0e9f666fcd702b7141d4e9a82e1085e44eb4470624e1a9d33"
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
