class Src < Formula
  desc "Simple revision control: RCS reloaded with a modern UI"
  homepage "http://www.catb.org/~esr/src/"
  url "http://www.catb.org/~esr/src/src-1.37.tar.gz"
  sha256 "1a5ff9e562f1191673523b65873017447fbde7935007668d422c6c2d01096067"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?src[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aa8c72853f2e883e0f4270da06f8fe3c454cd55e8ca068c9e934966b8842ab06"
  end

  head do
    url "https://gitlab.com/esr/src.git", branch: "master"
    depends_on "asciidoc" => :build
  end

  depends_on "rcs"

  uses_from_macos "python", since: :catalina

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog" if build.head?

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    require "pty"
    (testpath/"test.txt").write "foo"
    PTY.spawn("sh", "-c", "#{bin}/src commit -m hello test.txt; #{bin}/src status test.txt") do |r, _w, _pid|
      output = ""
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
      assert_match(/^=\s*test.txt/, output)
    end
  end
end
