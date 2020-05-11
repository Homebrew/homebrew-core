class When < Formula
  desc "Tiny personal calendar"
  homepage "http://www.lightandmatter.com/when/when.html"
  url "https://github.com/bcrowell/when/archive/1.1.40.tar.gz"
  sha256 "1363d48c32c4bb528514abf012ae0a61e7c686504a047ce870e72e791447c3d1"
  head "https://github.com/bcrowell/when.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cd236f241339384492d25773ecabbf9037ee4239d549791c425d29bef0a1dae9" => :catalina
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
