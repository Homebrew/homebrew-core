class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, TruffleRuby, or mruby"
  homepage "https://github.com/postmodern/ruby-install#readme"
  url "https://github.com/postmodern/ruby-install/archive/v0.7.0.tar.gz"
  sha256 "500a8ac84b8f65455958a02bcefd1ed4bfcaeaa2bb97b8f31e61ded5cd0fd70b"
  head "https://github.com/postmodern/ruby-install.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8141c3baa93dedadbdeba6d02a0d00ad13493ba052d013807a40ac048617c6da" => :catalina
    sha256 "df0319ebf05c4b0700f16b0bd3150f53d3034a4b664d8d10c3f190af266cdbe4" => :mojave
    sha256 "0e88bbe463d29a1e1cc0a91816023346a860a8a08c3daff660c24b313d2b4511" => :high_sierra
    sha256 "0e88bbe463d29a1e1cc0a91816023346a860a8a08c3daff660c24b313d2b4511" => :sierra
    sha256 "0e88bbe463d29a1e1cc0a91816023346a860a8a08c3daff660c24b313d2b4511" => :el_capitan
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ruby-install"
  end
end
