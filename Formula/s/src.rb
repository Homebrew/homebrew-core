class Src < Formula
  desc "Simple revision control: RCS reloaded with a modern UI"
  homepage "http://www.catb.org/~esr/src/"
  url "http://www.catb.org/~esr/src/src-1.32.tar.gz"
  sha256 "0920350a63ef5ee3a5f4fcd7f7bfeca0646ad871c1718b80e4f7a939531a3165"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?src[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5cbfa8adeb53bfa81b0e81f53cf8f0f10231bc80ba9ffc80ad94432fe4c814fd"
  end

  head do
    url "https://gitlab.com/esr/src.git", branch: "master"
    depends_on "asciidoc" => :build
  end

  depends_on "python@3.11"
  depends_on "rcs"

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
