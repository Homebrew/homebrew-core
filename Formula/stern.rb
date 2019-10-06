class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/wercker/stern"
  url "https://github.com/wercker/stern/archive/1.11.0.tar.gz"
  sha256 "d6f47d3a6f47680d3e4afebc8b01a14f0affcd8fb625132af14bb77843f0333f"
  head "https://github.com/wercker/stern.git",
    :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "886c99c34ee64ae8ea2292822b268324b573449fb3d621b874c0746d071a5082" => :catalina
    sha256 "f862bab034a7d05b995e762e7feae5d840db9099faba8465e4e20daa548f02f7" => :mojave
    sha256 "fd68b5ceb1ef3a1cbdb51653530f0ac0625e59adb55b02c1b7dad2268db7e4b3" => :high_sierra
    sha256 "01a7f817326d1172201d36df18cbee1ceca864d83e9cc528e301018b1510872f" => :sierra
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
