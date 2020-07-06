class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https://serfdom.io/"
  url "https://github.com/hashicorp/serf.git",
      :tag      => "v0.9.2",
      :revision => "5642cc7572cebea332176ca3024bec4b3474a11a"
  license "MPL-2.0"
  head "https://github.com/hashicorp/serf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3bd356983857810d36a2ea7c3ae785a93068a502c3c371ccbf9b5db5b43c7a77" => :catalina
    sha256 "8fc8a0b90605b7f45e55bbd3334aeedf02feec63f1b1e6d0de0ce473ad575be2" => :mojave
    sha256 "1b0dbf9abeb34aae2e0b1634f274d46b7bd95a166dfff360fe54599de68415c6" => :high_sierra
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
