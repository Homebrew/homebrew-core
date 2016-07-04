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
    sha256 "eee31563767f08c15976ec06c6a0fa547480aeaefd5187fd67aa97e90f4bfa96" => :el_capitan
    sha256 "df2a3094381047b830ab471af7dd013bbd85f8dcb6e22fba31dfe3a33d7be1ea" => :yosemite
    sha256 "3bf0eec92d2a86fd6a527aaa9c9215ba67154625c4654ff46f4e4d62742016a0" => :mavericks
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
