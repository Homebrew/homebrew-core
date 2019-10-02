class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https://serfdom.io/"
  url "https://github.com/hashicorp/serf.git",
      :tag      => "v0.8.5",
      :revision => "1d3fdf93bbe5002c5023da50402368a817488691"
  head "https://github.com/hashicorp/serf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd88e3a0f3d7e3cbca0d4f3d37fa9c5de8db2690ec7e7f8823181b144cbc614b" => :mojave
    sha256 "007c72e77f6f1167686c82cb5f25f7439544e3711878c617f3ff407fb5dc67cc" => :high_sierra
    sha256 "80c69509ae669bdcbad424d9fb72c2e97a444b702f551b4de602875b134229d6" => :sierra
  end

  depends_on "go" => :build
  depends_on "govendor" => :build
  depends_on "gox" => :build

  def install
    contents = Dir["*"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/hashicorp/serf").install contents

    ENV["GOPATH"] = gopath
    ENV["XC_ARCH"] = "amd64"
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
