class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https://serfdom.io/"
  url "https://github.com/hashicorp/serf.git",
      :tag => "v0.8.1",
      :revision => "d6574a5bb1226678d7010325fb6c985db20ee458"
  head "https://github.com/hashicorp/serf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5056682baba23b724e2162d57ef3ec4d44ffe6065ce0e4b5ee070c283e6bb212" => :high_sierra
    sha256 "bd635f302248c8e6a6063fb5496890743f94629af4f039be3089e59ca2b3ceab" => :sierra
    sha256 "b17ca576f35a45bc4b60272166a035d07b6d70c4b88a191e9d151a13f8d234f1" => :el_capitan
    sha256 "10eaf8cf838a3b49612fd7b66e3b5b3f36a41aa383e3735e5748a44d1f037266" => :yosemite
  end

  depends_on "go" => :build
  depends_on "govendor" => :build
  depends_on "gox" => :build

  def install
    contents = Dir["*"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/hashicorp/serf").install contents

    ENV["GOPATH"] = gopath
    arch = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["XC_ARCH"] = arch
    ENV["XC_OS"] = "darwin"

    (gopath/"bin").mkpath

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
