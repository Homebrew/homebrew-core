class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, TruffleRuby, or mruby"
  homepage "https://github.com/postmodern/ruby-install#readme"
  url "https://github.com/postmodern/ruby-install/archive/v0.7.1.tar.gz"
  sha256 "2a082504f81b6017e8f679f093664fff9b6a282f8df4c9eb0a200643be3fcb56"
  license "MIT"
  head "https://github.com/postmodern/ruby-install.git"

  bottle do
    cellar :any_skip_relocation
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
