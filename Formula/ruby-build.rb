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
    Warning: without further action ruby-build will download and install OpenSSL outside of Homebrew, and never update it.

    To avoid this, set the following environment variable in your shell:
      export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl)"

    However, note that if you do this, it will interfere with building end of life rubies that still use OpenSSL 1.0.
  EOS
  end

  test do
    assert_match "2.0.0", shell_output("#{bin}/ruby-build --definitions")
  end
end
