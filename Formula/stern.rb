class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/wercker/stern"
  url "https://github.com/wercker/stern/archive/1.8.0.tar.gz"
  sha256 "e9c60dbbc35ff2982081e4ea4509d1cde4d3ce033ce5e74e7fffaad8f7ef540a"
  head "https://github.com/wercker/stern.git",
    :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "36dc29b51837d012b3ebcd16ee812708c0853e03a953e7cb275b24d74ed9e837" => :mojave
    sha256 "c503a548f27a1f3d14bfa8cb8be7224981098c7bb4c72ead1b4f492490d28200" => :high_sierra
    sha256 "14fa8371954f1ff8555553e67687061e23e9a9634adbbd3673d3e80c9df2baa8" => :sierra
    sha256 "dbf1bfa163ad8f6793a248e35f2c0c4a21fe1cf5162ab97b9c275166ee363c77" => :el_capitan
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
