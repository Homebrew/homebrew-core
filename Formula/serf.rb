require "language/go"

class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https://serfdom.io/"
  url "https://github.com/hashicorp/serf.git",
      :tag => "v0.8.0",
      :revision => "b9642a47e6139e50548b6f14588a1a3c0839660a"
  revision 1

  head "https://github.com/hashicorp/serf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fcc9dfe253765e3eaed1107832fd62df4d7543f34277daf28dc9973f8f735597" => :sierra
    sha256 "007baecf7627b4135ddc6808ab3f7a40586b1235627cebee4d62cc0af9aee5eb" => :el_capitan
    sha256 "694a32fb05387ec3c3ee5b9698ee6569aca9954cbdf58e6e5ab1d4693a4f4aa8" => :yosemite
    sha256 "7bf755b79e60cc24da1002d2412d3579b3053d15d0cd8aed79277070f453c3ce" => :mavericks
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
        :revision => "c9740af9c6574448fd48eb30a71f964014c7a837"
  end

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
        :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  def install
    contents = Dir["*"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/hashicorp/serf").install contents

    ENV["GOPATH"] = gopath
    arch = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["XC_ARCH"] = arch
    ENV["XC_OS"] = "darwin"

    Language::Go.stage_deps resources, gopath/"src"

    ENV.prepend_create_path "PATH", gopath/"bin"
    cd gopath/"src/github.com/mitchellh/gox" do
      system "go", "build"
      (gopath/"bin").install "gox"
    end

    cd gopath/"src/github.com/hashicorp/serf" do
      system "make", "bin"
      bin.install "bin/serf"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/serf", "agent"
      end
      sleep 1
      assert_match /:7946.*alive$/, shell_output("#{bin}/serf members")
    ensure
      system "#{bin}/serf", "leave"
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
