class When < Formula
  desc "Tiny personal calendar"
  homepage "https://www.lightandmatter.com/when/when.html"
  url "https://github.com/bcrowell/when/archive/1.1.41.tar.gz"
  sha256 "78bfd3f18e0d3e42797c7aacb16829d2354d935f12e04db9e467d4bec389c884"
  head "https://github.com/bcrowell/when.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a81c9f8df331f75089bb37fd5fba3c21b5af8cb78688aa581a0dc68576e6eb30"
    sha256 cellar: :any_skip_relocation, big_sur:       "a81c9f8df331f75089bb37fd5fba3c21b5af8cb78688aa581a0dc68576e6eb30"
    sha256 cellar: :any_skip_relocation, catalina:      "8d8383bec0c3e96f4fa43ba2dc9ef211bd8e0904a5bdca8c55dc1f6a802d3709"
    sha256 cellar: :any_skip_relocation, mojave:        "8d8383bec0c3e96f4fa43ba2dc9ef211bd8e0904a5bdca8c55dc1f6a802d3709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f0d85ac2cb2705e1d733a968530d190fac54796a70ba63d1010026b5ec76a2c"
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
