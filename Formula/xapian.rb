class Xapian < Formula
  desc "C++ search engine library with many bindings"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.7/xapian-core-1.4.7.tar.xz"
  mirror "https://fossies.org/linux/www/xapian-core-1.4.7.tar.xz"
  sha256 "13f08a0b649c7afa804fa0e85678d693fd6069dd394c9b9e7d41973d74a3b5d3"

  bottle do
    cellar :any
    rebuild 1
    sha256 "424ac432e892cfc455f6fcd8ae7608b44d76d39a73361b3b56d143ac30921b8c" => :mojave
    sha256 "32e3b96b619d8f39e6f2d5a32fb0f9b9fb0e1378fcfdbb2a163eb549798e10e1" => :high_sierra
    sha256 "adfbefe2380111b93f1ebce01311bf8a1d07f91715e90b33134457604772d41d" => :sierra
  end

  option "with-ruby", "Ruby bindings"

  deprecated_option "ruby" => "with-ruby"

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

    if build.with?("ruby")
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
