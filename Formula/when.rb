class When < Formula
  desc "Tiny personal calendar"
  homepage "http://www.lightandmatter.com/when/when.html"
  url "https://deb.debian.org/debian/pool/main/w/when/when_1.1.38.orig.tar.gz"
  sha256 "139834945142f5e3ea6b20f43ba740d30b4a87b42ce5767026094e633dca999f"
  head "https://github.com/bcrowell/when.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6d9163386a8a6648be9cbb9059d08d81fc87cd28503f7ae55883afb497990d68" => :mojave
    sha256 "07fe70f0124a3efbf0a2119ff407aa5089316e3504ca7b9eda7a38f619fff7ae" => :high_sierra
    sha256 "07fe70f0124a3efbf0a2119ff407aa5089316e3504ca7b9eda7a38f619fff7ae" => :sierra
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/".when/preferences").write <<~EOS
      calendar = #{testpath}/calendar
    EOS

    (testpath/"calendar").write "2015 April 1, stay off the internet"
    system bin/"when", "i"
  end
end
