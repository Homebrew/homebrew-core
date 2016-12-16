class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers."
  homepage "https://github.com/wercker/stern"
  url "https://github.com/wercker/stern/archive/1.1.0.tar.gz"
  sha256 "91c77d28623fdf0a2fd6b9ab7afbe5c5300fa742431ce98cf2dab476b9b2dc42"

  head "https://github.com/wercker/stern",
    :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "27cc978c52be66afcb7a6bac518c1b33cc55191c0e3a821cba680e924128b3fd" => :sierra
    sha256 "37ed3282c6d918e6e3147403d26223014388b3563055e1a313e1e8a647076bd2" => :el_capitan
    sha256 "55c898a08528ab72fed8e0c6de40524c1d48c556e1bb5ce1ea817595e0b66386" => :yosemite
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
