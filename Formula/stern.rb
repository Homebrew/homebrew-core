class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers."
  homepage "https://github.com/wercker/stern"
  url "https://github.com/wercker/stern/archive/1.4.0.tar.gz"
  sha256 "32c65ad4710bb84ab187443f78d1016c9e76b18ef7396c841571bf2ce9907b2b"

  head "https://github.com/wercker/stern.git",
    :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "4c2136c7e92177ce888ecf552570ab5722731c0ff09d09497682078f8fa1bf90" => :sierra
    sha256 "d25a88970f952b7f05de8aaa9698e0f00add5ff8eb5e065c5060ab5b51f607ac" => :el_capitan
    sha256 "e8b7b50252464d9d4ff135be76f7e08f58f17c9100d6cba757fdc5af213265a8" => :yosemite
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/wercker/stern").install contents

    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    cd gopath/"src/github.com/wercker/stern" do
      system "govendor", "sync"
      system "go", "build", "-o", "bin/stern"
      bin.install "bin/stern"
    end
  end

  test do
    system "#{bin}/stern", "--version"
  end
end
