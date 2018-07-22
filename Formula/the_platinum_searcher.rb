class ThePlatinumSearcher < Formula
  desc "Multi-platform code-search similar to ack and ag"
  homepage "https://github.com/monochromegane/the_platinum_searcher"
  url "https://github.com/monochromegane/the_platinum_searcher/archive/v2.1.6.tar.gz"
  sha256 "257c76d3fb1d6571ea690a0ced8301b1ef827333474ca7dd9164ac1a2272034e"
  head "https://github.com/monochromegane/the_platinum_searcher.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e39dbe62965c85bb8f6c0dc00624f9bcdb3a0f17d80b861e5233d6570646b85" => :high_sierra
    sha256 "0d66a9175ea54b3d118f3b5a0f99a0ec38b9140a0326332b01fde7417d8d323b" => :sierra
    sha256 "a4666a07dcdcb843529039d662ea11626c288847d4afc456804e031a7811abbd" => :el_capitan
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
