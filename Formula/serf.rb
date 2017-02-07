require "language/go"

class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https://serfdom.io/"
  url "https://github.com/hashicorp/serf.git",
      :tag => "v0.8.1",
      :revision => "d6574a5bb1226678d7010325fb6c985db20ee458"
  head "https://github.com/hashicorp/serf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd0e819a717954bc52d8ae357250f8165354e8c165cb0d51a2530fdb6d1f25e8" => :sierra
    sha256 "2dc6397d3b2fab1216b3d42346557d3284bb5837fe280ea3eb09ffbc75fafb23" => :el_capitan
    sha256 "48d82da98e80a3d8f69cf761afea04d61f7a0f2a0d2330a29de519a379c578fc" => :yosemite
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
