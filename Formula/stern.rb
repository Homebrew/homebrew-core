class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/wercker/stern"
  url "https://github.com/wercker/stern/archive/1.7.0.tar.gz"
  sha256 "28a2ea67634c3ad352cf6cea1efb77885de274f885467a2898233048b007164a"

  head "https://github.com/wercker/stern.git",
    :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "9617a94ec4773c85dd7a28e446f9439f42695ebbbd56ecb7139fadfd6b108c5f" => :high_sierra
    sha256 "f5db4e36669669d56a1d703b80a031c785a0eddff3ef250e6e26fcc0405595c9" => :sierra
    sha256 "083540d9629161c13d48c7ea3cdc29ddb7a120b837399168e11fef9b1e6e1243" => :el_capitan
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
