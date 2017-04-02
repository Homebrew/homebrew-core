class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers."
  homepage "https://github.com/wercker/stern"
  url "https://github.com/wercker/stern/archive/1.3.0.tar.gz"
  sha256 "f78b8bb88cc0d888226f91002e9553c837081d6f0bd72c9e4fbce6cbbced7615"

  head "https://github.com/wercker/stern",
    :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "29ea851395807715565c0c0b57db219fa2179bb5112145c635dc99750dcf6d47" => :sierra
    sha256 "12feb38b3536c7e3c64c255564d9b22b5cb9cea34f6cf6ff1d5d2de0d694a758" => :el_capitan
    sha256 "aaebfee6d6dfd03a9ce310669f48397469b20a726b427cf4783427d476509ca6" => :yosemite
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
