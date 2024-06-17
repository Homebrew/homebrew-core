class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/rbenv/ruby-build"
  url "https://github.com/rbenv/ruby-build/archive/refs/tags/v20240612.tar.gz"
  sha256 "3502a4a744a95ceedd48cc9de8c171b808184b2a6ab1f6489fbd69d501c496be"
  license "MIT"
  head "https://github.com/rbenv/ruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d71fde2068331313d1a3bdb51c323c965f3ac356e032ed8832a2e2ade43be6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d71fde2068331313d1a3bdb51c323c965f3ac356e032ed8832a2e2ade43be6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d71fde2068331313d1a3bdb51c323c965f3ac356e032ed8832a2e2ade43be6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d71fde2068331313d1a3bdb51c323c965f3ac356e032ed8832a2e2ade43be6c"
    sha256 cellar: :any_skip_relocation, ventura:        "0d71fde2068331313d1a3bdb51c323c965f3ac356e032ed8832a2e2ade43be6c"
    sha256 cellar: :any_skip_relocation, monterey:       "0d71fde2068331313d1a3bdb51c323c965f3ac356e032ed8832a2e2ade43be6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8e55424f2ba0d2681069e66357ff86049bf24bb569ecf386625eaf8dc4b774e"
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
