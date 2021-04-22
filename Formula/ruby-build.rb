class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/rbenv/ruby-build"
  url "https://github.com/rbenv/ruby-build/archive/v20210423.tar.gz"
  sha256 "bffdf6f9572a9a2d3cf6d9cbc44a27470b5c9b77009abd3489876a2e452e44ac"
  license "MIT"
  head "https://github.com/rbenv/ruby-build.git"

  depends_on "autoconf"
  depends_on "pkg-config"
  depends_on "readline"

  def install
    # these references are (as-of v20210420) only relevant on FreeBSD but they
    # prevent having identical bottles between platforms so let's fix that.
    inreplace "bin/ruby-build", "/usr/local", HOMEBREW_PREFIX

    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  def caveats
    <<~EOS
      ruby-build installs a non-Homebrew OpenSSL for each Ruby version installed and these are never upgraded.

      To link Rubies to Homebrew's OpenSSL 1.1 (which is upgraded) add the following
      to your #{shell_profile}:
        export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

      Note: this may interfere with building old versions of Ruby (e.g <2.4) that use
      OpenSSL <1.1.
    EOS
  end

  test do
    assert_match "2.0.0", shell_output("#{bin}/ruby-build --definitions")
  end
end
