class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https://serfdom.io/"
  url "https://github.com/hashicorp/serf.git",
      :tag      => "v0.8.5",
      :revision => "1d3fdf93bbe5002c5023da50402368a817488691"
  head "https://github.com/hashicorp/serf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9afe67fdeaf09ae3a801c700c25148e86da33f036d92f5260ce085fe95d4ac57" => :catalina
    sha256 "591a05d111d305a1a20bf9e7971f5475206b737504aec9a72d0e7c64d86a4efb" => :mojave
    sha256 "7cf67630dd3839a5e59eb92997c4cc9034bce06dbc72f1b75cf4e36a2b3cfe60" => :high_sierra
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
