class Zrepl < Formula
  desc "One-stop ZFS backup & replication solution"
  homepage "https://zrepl.github.io"
  url "https://github.com/zrepl/zrepl/archive/v0.1.1.tar.gz"
  sha256 "0c16554e4527d14a390d78cf95bce759da425019a83ec63acfed5b4c50d68c9c"
  head "https://github.com/zrepl/zrepl.git"

  depends_on "go" => :build

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/zrepl/zrepl").install contents

    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"    
    cd gopath/"src/github.com/zrepl/zrepl" do
      system "./lazy.sh",  "godep"
      system "make", "ZREPL_VERSION=0.1.1"
      bin.install "artifacts/zrepl"
    end      
  end

  test do
    system "#{bin}/zrepl", "help"
  end
end
