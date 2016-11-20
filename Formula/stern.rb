class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers."
  homepage "https://github.com/wercker/stern"
  url "https://github.com/wercker/stern/archive/1.0.1.tar.gz"
  sha256 "9ae06c436dad6fff4c24243d37c34efed11d3abf76845a75e3ccbaee64f1c021"

  head "https://github.com/wercker/stern",
    :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "80ce66cd5760263686da9d66f32d55f42343fa3001cbb93f31fba891d3cfad73" => :sierra
    sha256 "88115c5a05403037defbf44e5177a3565504b9a2cf3c0499a8ff89528ae4ab72" => :el_capitan
    sha256 "602e2363ccf22874d3cf6bb52fe3d2db4964e667e27d5b1972bc4a64532e6aef" => :yosemite
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
