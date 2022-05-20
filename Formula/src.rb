class Src < Formula
  desc "Simple revision control: RCS reloaded with a modern UI"
  homepage "http://www.catb.org/~esr/src/"
  url "http://www.catb.org/~esr/src/src-1.29.tar.gz"
  sha256 "4dcfaa0612ed0bdbb6dc1aea567880a6b015f1885710bbdb327f97c4de414241"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?src[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1be6e1ab14e7503ebe94f2e896af8c3e9d605232e3ea18f09f7248a2350f90e4"
  end

  head do
    url "https://gitlab.com/esr/src.git", branch: "master"
    depends_on "asciidoc" => :build
  end

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
