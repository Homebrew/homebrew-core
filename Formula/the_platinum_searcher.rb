class ThePlatinumSearcher < Formula
  desc "Multi-platform code-search similar to ack and ag"
  homepage "https://github.com/monochromegane/the_platinum_searcher"
  url "https://github.com/monochromegane/the_platinum_searcher/archive/v2.1.5.tar.gz"
  sha256 "dfed3b92f35501d063a2c646d5dfd51f2ee12cee53dd9e1d04a6c7710b71050f"
  head "https://github.com/monochromegane/the_platinum_searcher.git"

  bottle do
    sha256 "081c4a087043d368597933f4ccea9e85d8302a3961940527780138e19ea1648a" => :sierra
    sha256 "087aaf0fc00872ca2f764fcc44d474f4dd03b3f78eace1b60fa269761ccfb7da" => :el_capitan
    sha256 "3421b685e500033f24120ae6b80ca7f932eb476b4a85cfb4813447f36ec6bcb6" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/monochromegane/the_platinum_searcher"
    dir.install buildpath.children
    cd dir do
      system "godep", "restore"
      system "go", "build", "-o", bin/"pt", ".../cmd/pt"
      prefix.install_metafiles
    end
  end

  test do
    path = testpath/"hello_world.txt"
    path.write "Hello World!"

    lines = `#{bin}/pt 'Hello World!' #{path}`.strip.split(":")
    assert_equal "Hello World!", lines[2]
  end
end
