class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/rbenv/ruby-build"
  url "https://github.com/rbenv/ruby-build/archive/refs/tags/v20240727.tar.gz"
  sha256 "c6359deb8694e19c00af37cadef239af7e3f00e63d89e9333870bbb0178d039c"
  license "MIT"
  head "https://github.com/rbenv/ruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "811b8eb8aa96f06313e825ca30f2374bfcdf1a11a972564eab5bced5b16fcb6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "811b8eb8aa96f06313e825ca30f2374bfcdf1a11a972564eab5bced5b16fcb6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "811b8eb8aa96f06313e825ca30f2374bfcdf1a11a972564eab5bced5b16fcb6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "811b8eb8aa96f06313e825ca30f2374bfcdf1a11a972564eab5bced5b16fcb6d"
    sha256 cellar: :any_skip_relocation, ventura:        "811b8eb8aa96f06313e825ca30f2374bfcdf1a11a972564eab5bced5b16fcb6d"
    sha256 cellar: :any_skip_relocation, monterey:       "811b8eb8aa96f06313e825ca30f2374bfcdf1a11a972564eab5bced5b16fcb6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80f4a70f489236ec8682fc27b7f1b791bc65da84915cf1467bc6c15fe33fbeab"
  end

  depends_on "autoconf"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pkg-config"
  depends_on "readline"

  def install
    # these references are (as-of v20210420) only relevant on FreeBSD but they
    # prevent having identical bottles between platforms so let's fix that.
    inreplace "bin/ruby-build", "/usr/local", HOMEBREW_PREFIX

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "2.0.0", shell_output("#{bin}/ruby-build --definitions")
  end
end
