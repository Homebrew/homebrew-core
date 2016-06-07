require "language/go"

class ThePlatinumSearcher < Formula
  desc "Multi-platform code-search similar to ack and ag"
  homepage "https://github.com/monochromegane/the_platinum_searcher"
  url "https://github.com/monochromegane/the_platinum_searcher/archive/v2.1.2.tar.gz"
  sha256 "db8cbe30381e7f0a6cdb4b8ab306194483df16197b268790b6d8cee3f8d32d05"
  revision 1
  head "https://github.com/monochromegane/the_platinum_searcher.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a707dbf5be883bbfc87279774ecd09979a4e089ce2dbee17b57a6a45b0bd0432" => :el_capitan
    sha256 "5324f347210586ca770d21c2004867b7be67fa6191c05657ebf8b2e2ef30544e" => :yosemite
    sha256 "a7ee9ef3b664c9690c3e0e7c53a4b48fa73f63d7ad8fd5e425ac3ad6a8dc19f3" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/monochromegane/the_platinum_searcher"
    dir.install Dir["*"]
    ln_s buildpath/"src", dir
    cd dir do
      system "godep", "restore"
      system "go", "build", "-o", bin/"pt", "cmd/pt/main.go"
    end
  end

  test do
    path = testpath/"hello_world.txt"
    path.write "Hello World!"

    lines = `#{bin}/pt 'Hello World!' #{path}`.strip.split(":")
    assert_equal "Hello World!", lines[2]
  end
end
