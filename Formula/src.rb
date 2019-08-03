class Src < Formula
  desc "Simple revision control: RCS reloaded with a modern UI"
  homepage "http://www.catb.org/~esr/src/"
  url "http://www.catb.org/~esr/src/src-1.26.tar.gz"
  sha256 "435c457f9f577d84ae1fd763e2bd3548d84f84c50cd2c88f664fba259cd5d71a"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5da1fd27c011587281c2e991f53e03c06b32e78b23d293be173141ca007be73" => :mojave
    sha256 "7b8177edd573490081ab245c28b9b7d93ad333837d754d6ec444461977f79e3d" => :high_sierra
    sha256 "7b8177edd573490081ab245c28b9b7d93ad333837d754d6ec444461977f79e3d" => :sierra
    sha256 "7b8177edd573490081ab245c28b9b7d93ad333837d754d6ec444461977f79e3d" => :el_capitan
  end

  head do
    url "https://gitlab.com/esr/src.git"
    depends_on "asciidoc" => :build
  end

  depends_on "rcs"

  conflicts_with "srclib", :because => "both install a 'src' binary"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog" if build.head?

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.txt").write "foo"
    system "#{bin}/src", "commit", "-m", "hello", "test.txt"
    system "#{bin}/src", "status", "test.txt"
  end
end
