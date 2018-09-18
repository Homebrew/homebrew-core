class Xapian < Formula
  desc "C++ search engine library with many bindings"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.7/xapian-core-1.4.7.tar.xz"
  mirror "https://fossies.org/linux/www/xapian-core-1.4.7.tar.xz"
  sha256 "13f08a0b649c7afa804fa0e85678d693fd6069dd394c9b9e7d41973d74a3b5d3"

  bottle do
    cellar :any
    sha256 "72404e4891d872f5e80d4af61f6692c62457673ae888c89190c0c13de022ead6" => :mojave
    sha256 "088f14bc829dbafed8e02666e7f6a276c7013c6b04d0e3eb0a9602c2605aaec8" => :high_sierra
    sha256 "95e3a0b7950ef9b51ed0c385f9431f1f99a883fef3790de851fca3ea741e051b" => :sierra
    sha256 "1ee62f239e87de8a4ba26c7f74eaefff7ec4841e83a01dbcf14d4a2c712781c0" => :el_capitan
  end

  option "with-ruby", "Ruby bindings"

  deprecated_option "ruby" => "with-ruby"
  deprecated_option "with-python" => "with-python@2"

  depends_on "python@2" => :optional
  depends_on "sphinx-doc" => :build if build.with? "python@2"
  depends_on "ruby" => :optional if MacOS.version <= :sierra

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.7/xapian-bindings-1.4.7.tar.xz"
    sha256 "4519751376dc5b59893b812495e6004fd80eb4a10970829aede71a35264b4e6a"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    if build.with?("ruby") || build.with?("python@2")
      resource("bindings").stage do
        ENV["XAPIAN_CONFIG"] = bin/"xapian-config"

        args = %W[
          --disable-dependency-tracking
          --prefix=#{prefix}
        ]

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
