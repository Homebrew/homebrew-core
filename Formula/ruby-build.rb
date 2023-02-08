class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/rbenv/ruby-build"
  url "https://github.com/rbenv/ruby-build/archive/v20230208.1.tar.gz"
  sha256 "c4fca40b3a4646a9295c8d5e8b0535a194ae45228c326629e1455b8a87697c6d"
  license "MIT"
  head "https://github.com/rbenv/ruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da2aad7da7a965a9210b00c89d962c523b87d280947513237f75375e3ae86d77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c530e52acfdbb815b7f348eebf793342cfd3cd74a2f148bb95514c516fba7a46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "169c6995f66d17e9ca477b739ea896956d70a1c3ecb1057661b98c3034c8f946"
    sha256 cellar: :any_skip_relocation, ventura:        "6d48a44680b49ab4df425c698d09c2e91f48345906b21e0c8ec2a809039434f2"
    sha256 cellar: :any_skip_relocation, monterey:       "6f49bbbee0db2284e48fd0061226549ef4690bb03901fae9c35d31809c8e1b4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f29e369b551871440d4aca043d2771a1e3a7ef2f01f531a5d4a1d938ac7a291"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87a5c809d0f0e9e9ac5fc96f4eddd6df856b99c452086d8b41a442535623551e"
  end

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
