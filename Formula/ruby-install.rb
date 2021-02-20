class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, TruffleRuby, or mruby"
  homepage "https://github.com/postmodern/ruby-install#readme"
  url "https://github.com/postmodern/ruby-install/archive/v0.8.1.tar.gz"
  sha256 "d96fce7a4df70ca7a367400fbe035ff5b518408fc55924966743abf66ead7771"
  license "MIT"
  head "https://github.com/postmodern/ruby-install.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2bebe2b7b3f62bf84c92a2e7f13a30be214cb7dc0a849479102c1826e7974fcc"
    sha256 cellar: :any_skip_relocation, big_sur:       "a7f9e33147703ddd362a07bb361f381b99ff5d936b1102108812ed08c4ccf386"
    sha256 cellar: :any_skip_relocation, catalina:      "0116171fc93d09c4893e7b88e8202b641f028f7e74817aff8f44952f792ad8b0"
    sha256 cellar: :any_skip_relocation, mojave:        "6ab943b1a3882cb2e81099dc9870e364dcbbd4d40685227f2b6a89fcc37e896c"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ruby-install"
  end
end
