class Src < Formula
  desc "Simple revision control: RCS reloaded with a modern UI"
  homepage "http://www.catb.org/~esr/src/"
  url "http://www.catb.org/~esr/src/src-1.18.tar.gz"
  sha256 "cc0897c1763f57e6627fd912a315de5554e4bb53fa0958c8578223e5379c1a58"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5da1fd27c011587281c2e991f53e03c06b32e78b23d293be173141ca007be73" => :mojave
    sha256 "7b8177edd573490081ab245c28b9b7d93ad333837d754d6ec444461977f79e3d" => :high_sierra
    sha256 "7b8177edd573490081ab245c28b9b7d93ad333837d754d6ec444461977f79e3d" => :sierra
    sha256 "7b8177edd573490081ab245c28b9b7d93ad333837d754d6ec444461977f79e3d" => :el_capitan
  end

  head do
    url "git://thyrsus.com/repositories/src.git"
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
