class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers."
  homepage "https://github.com/wercker/stern"
  url "https://github.com/wercker/stern/archive/1.3.0.tar.gz"
  sha256 "f78b8bb88cc0d888226f91002e9553c837081d6f0bd72c9e4fbce6cbbced7615"

  head "https://github.com/wercker/stern",
    :shallow => false

  bottle do
    sha256 "9d4132b959e849104478bee303de9d8e3072ce92c8b185650f8eca251c2aef7c" => :sierra
    sha256 "ffd3fe0afd636bf2724e53f01658fd0819e7af4007ccbacf09f73a2899f21ac2" => :el_capitan
    sha256 "388d15c31e4e1e7991b1c91e8b95a4955883e1a5a412a6ca63d1e45c96afd46d" => :yosemite
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
