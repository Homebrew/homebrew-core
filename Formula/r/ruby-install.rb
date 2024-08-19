class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, TruffleRuby, or mruby"
  homepage "https://github.com/postmodern/ruby-install"
  url "https://github.com/postmodern/ruby-install/releases/download/v0.9.3/ruby-install-0.9.3.tar.gz"
  sha256 "f1cc6c2fdba5591d7734c92201cca0dadb34038f8159ab89e0cf4e096ebb310a"
  license "MIT"
  head "https://github.com/postmodern/ruby-install.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73c1bedce047ff55b1fbabf5dea434652a014aaef1af51cfe01c48ae015c8119"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73c1bedce047ff55b1fbabf5dea434652a014aaef1af51cfe01c48ae015c8119"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73c1bedce047ff55b1fbabf5dea434652a014aaef1af51cfe01c48ae015c8119"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d004f550287b5f06a7435c139b8971c1b86322a900ade4ba236be8d5239df98"
    sha256 cellar: :any_skip_relocation, ventura:        "3d004f550287b5f06a7435c139b8971c1b86322a900ade4ba236be8d5239df98"
    sha256 cellar: :any_skip_relocation, monterey:       "73c1bedce047ff55b1fbabf5dea434652a014aaef1af51cfe01c48ae015c8119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73c1bedce047ff55b1fbabf5dea434652a014aaef1af51cfe01c48ae015c8119"
  end

  depends_on "xz"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    # Ensure uniform bottles across prefixes
    inreplace man1/"ruby-install.1", "/usr/local", "$HOMEBREW_PREFIX"
    inreplace [
      pkgshare/"ruby-install.sh",
      pkgshare/"truffleruby/functions.sh",
      pkgshare/"truffleruby-graalvm/functions.sh",
    ], "/usr/local", HOMEBREW_PREFIX
  end

  test do
    system bin/"ruby-install"
  end
end
