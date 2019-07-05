class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/wercker/stern"
  url "https://github.com/wercker/stern/archive/1.11.0.tar.gz"
  sha256 "d6f47d3a6f47680d3e4afebc8b01a14f0affcd8fb625132af14bb77843f0333f"
  head "https://github.com/wercker/stern.git",
    :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "f3b4fc666d4d255347e0ea3e60bf96e0ee24860f652050c8094c906898237ddf" => :mojave
    sha256 "45a8fe1c99787e06b4334228509f94b6a194eb78355238e40a45a0be30084eb0" => :high_sierra
    sha256 "ee3eb750bf439ad47516bdade5a5c61819dfb70a60d164d89aca8e01060d7241" => :sierra
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
