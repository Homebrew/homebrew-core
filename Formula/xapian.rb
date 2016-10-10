class Xapian < Formula
  desc "C++ search engine library with many bindings"
  homepage "https://xapian.org/"

  stable do
    url "https://oligarchy.co.uk/xapian/1.2.23/xapian-core-1.2.23.tar.xz"
    sha256 "9783aeae4e1a6d06e5636b270db4b458a7d0804a31da158269f57fa5dc86347d"

    resource "bindings" do
      url "https://oligarchy.co.uk/xapian/1.2.23/xapian-bindings-1.2.23.tar.xz"
      sha256 "19b4b56c74863c51733d8c2567272ef7f004b898cf44016711ae25bc524b2215"
    end
  end

  bottle do
    cellar :any
    sha256 "6823c442511377fc5e214106fc037a818e3524ee89600135c58c32d4cbcff248" => :sierra
    sha256 "08232fd96069f4d80cf947a22d40a729bb9a65169e0c60eb59091041da987722" => :el_capitan
    sha256 "a076ee6fbab9f6eb3171171d9d54d68f2b6ffcabf88016d028b16bc68cfeafdf" => :yosemite
    sha256 "f881021eee674478fbd70179414d27e502a1de2751e8d4454f933551052b06fb" => :mavericks
  end

  devel do
    url "https://oligarchy.co.uk/xapian/1.3.5/xapian-core-1.3.5.tar.xz"
    mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/x/xapian-core/xapian-core_1.3.5.orig.tar.xz"
    sha256 "3ad99ff4e91a4ff997fd576377e7c8f0134ceb3695c49e8f7d78ebf3c19b70ad"

    resource "bindings" do
      url "https://oligarchy.co.uk/xapian/1.3.5/xapian-bindings-1.3.5.tar.xz"
      sha256 "4b5b9089d39b2a725651349127f64d24fe66db46572bdd92f39b8483bca400c3"
    end
  end

  option "with-java", "Java bindings"
  option "with-php", "PHP bindings"
  option "with-ruby", "Ruby bindings"

  deprecated_option "java" => "with-java"
  deprecated_option "php" => "with-php"
  deprecated_option "ruby" => "with-ruby"

  depends_on :python => :optional

  skip_clean :la

  def install
    build_binds = build.with?("ruby") || build.with?("python") || build.with?("java") || build.with?("php")

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    if build_binds
      resource("bindings").stage do
        args = %W[
          --disable-dependency-tracking
          --prefix=#{prefix}
          XAPIAN_CONFIG=#{bin}/xapian-config
          --without-csharp
          --without-tcl
        ]

        if build.with? "java"
          args << "--with-java"
        else
          args << "--without-java"
        end

        if build.with? "ruby"
          ruby_site = lib/"ruby/site_ruby"
          ENV["RUBY_LIB"] = ENV["RUBY_LIB_ARCH"] = ruby_site
          args << "--with-ruby"
        else
          args << "--without-ruby"
        end

        if build.with? "python"
          # https://github.com/Homebrew/homebrew-core/issues/2422
          ENV.delete("PYTHONDONTWRITEBYTECODE")

          (lib/"python2.7/site-packages").mkpath
          ENV["PYTHON_LIB"] = lib/"python2.7/site-packages"
          # configure looks for python2 and system python doesn't install one
          ENV["PYTHON"] = which "python"
          args << "--with-python"
        else
          args << "--without-python"
        end

        if build.with? "php"
          extension_dir = lib/"php/extensions"
          extension_dir.mkpath
          args << "--with-php" << "PHP_EXTENSION_DIR=#{extension_dir}"
        else
          args << "--without-php"
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
    suffix = devel? ? "-1.3" : ""
    system bin/"xapian-config#{suffix}", "--libs"
  end
end
