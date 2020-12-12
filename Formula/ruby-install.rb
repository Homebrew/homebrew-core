class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, TruffleRuby, or mruby"
  homepage "https://github.com/postmodern/ruby-install#readme"
  url "https://github.com/postmodern/ruby-install/archive/v0.8.0.tar.gz"
  sha256 "1b8614997201eb634a88039cc8da947a4af1ee338aaa8fbade623d6748cb0c30"
  license "MIT"
  head "https://github.com/postmodern/ruby-install.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c81184e66eb30d512f8f6ab320b71a221bffcfacfb5b10e1131d2e559238f237" => :big_sur
    sha256 "2c60a37228f97ef76c4f40c36b1a63d046a5d80acf5dc20d93183b81ccf1317a" => :catalina
    sha256 "2c60a37228f97ef76c4f40c36b1a63d046a5d80acf5dc20d93183b81ccf1317a" => :mojave
    sha256 "2c60a37228f97ef76c4f40c36b1a63d046a5d80acf5dc20d93183b81ccf1317a" => :high_sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ruby-install"
  end
end
