class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/rbenv/ruby-build"
  url "https://github.com/rbenv/ruby-build/archive/v20161225.tar.gz"
  sha256 "1d5f2f4c7a2315572946a62fd85954251e8407eda391011de0d9a872cf1726ec"
  head "https://github.com/rbenv/ruby-build.git"

  bottle :unneeded

  depends_on "autoconf" => [:recommended, :run]
  depends_on "pkg-config" => [:recommended, :run]
  depends_on "openssl" => :recommended

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    assert_match "2.0.0", shell_output("#{bin}/ruby-build --definitions")
  end
end
