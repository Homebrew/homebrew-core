class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/wercker/stern"
  url "https://github.com/wercker/stern/archive/1.7.0.tar.gz"
  sha256 "28a2ea67634c3ad352cf6cea1efb77885de274f885467a2898233048b007164a"

  head "https://github.com/wercker/stern.git",
    :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "a68996e613063c260146902daa371db533ae911f96a4836e0ad797f7fcf750df" => :high_sierra
    sha256 "c2499dd1dc239e477cf726824882505bcc8dec9dc88167c3ee8ce5bf97dd4c8e" => :sierra
    sha256 "a859e5e08c7b14c4dc73d0af89327658af4731c9d522929e930741c326adc3f2" => :el_capitan
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
