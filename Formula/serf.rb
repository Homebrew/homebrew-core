class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https://serfdom.io/"
  url "https://github.com/hashicorp/serf.git",
      :tag => "v0.8.1",
      :revision => "d6574a5bb1226678d7010325fb6c985db20ee458"
  head "https://github.com/hashicorp/serf.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0d8be85c8bfefa616e5d5adedfbdad9227f5a0c11b0939ff664bdce9a5940da6" => :mojave
    sha256 "fbd6c27169ceec3d52843b137d39313c59bd3495c26c7b88ff1eb29847971d31" => :high_sierra
    sha256 "62f1e4030ba05b8f3fe8d40b185941cf9f0dbc1b02f043e5629281f03dbdb147" => :sierra
    sha256 "45e961e406465c73fd72bcf7bd573ab3de740ab297c90287a02c5d4f6c38ebb0" => :el_capitan
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
