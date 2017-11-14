class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/wercker/stern"
  url "https://github.com/wercker/stern/archive/1.5.1.tar.gz"
  sha256 "f7a9afcbfd9d9ce2d7e933ac5390e55e900ad2c2cbcab4afcac2a1f4dc2210e4"

  head "https://github.com/wercker/stern.git",
    :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "348f89e4731e9fe018dbdb2b241e9456424c059be847377f9f0b6d86ea73c31b" => :high_sierra
    sha256 "84069ad767e638e916c00f13231a2f47170b79619e4cab1315aa85ceb7535fe4" => :sierra
    sha256 "8212fa765da479b688496e1bb69a5d16510aef99acbe8403007f557cb6f52449" => :el_capitan
    sha256 "7d57ea2096a2755619e99e75f0180307132663bb8e5fd9e5f3272cadb50ebe01" => :yosemite
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
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/stern", "--version"
  end
end
