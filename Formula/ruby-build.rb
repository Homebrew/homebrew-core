class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/rbenv/ruby-build"
  url "https://github.com/rbenv/ruby-build/archive/v20191205.tar.gz"
  sha256 "d8ffe806a215b3afacead72e766f293ce380c78a143911b84cdb5f33e20a5284"
  head "https://github.com/rbenv/ruby-build.git"

  bottle :unneeded

  depends_on "autoconf"
  depends_on "pkg-config"
  depends_on "readline"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  def caveats; <<~EOS
    Warning: By default, ruby-build installs additional copies of OpenSSL outside of Homebrew, for each individual Ruby version installed, and such instances of OpenSSL are never updated.

    To have all Ruby versions link to Homebrew's OpenSSL, which is upgraded over time, you can place this in your shell initialization file:
      export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

    Note that this might interfere with building end of life versions of Ruby, such as those older than Ruby 2.4, that still use OpenSSL 1.0.
  EOS
  end

  test do
    assert_match "2.0.0", shell_output("#{bin}/ruby-build --definitions")
  end
end
