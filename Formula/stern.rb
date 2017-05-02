class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers."
  homepage "https://github.com/wercker/stern"
  url "https://github.com/wercker/stern/archive/1.5.0.tar.gz"
  sha256 "2e2e1baef022fa850d5fc9ceb4053a35cd033e9059621c4cdabff874cb39cbaf"

  head "https://github.com/wercker/stern.git",
    :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "33146c5768cd6dcc101fe5557b61b937cd550e61d6be34b44088351e6de7cdd1" => :sierra
    sha256 "7ccf008b8e3db8f8afcc8047b144a036f8d985615231576641fb46e3cbce35dc" => :el_capitan
    sha256 "cefee06366dee336ce9cb3996b1c2d45c584e5fa3dab9a17e55638be19ac4e43" => :yosemite
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
