class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/v0.1.x/en/"
  url "https://github.com/rancher/rke.git",
      :tag      => "v0.3.0",
      :revision => "9a03d8020bdf82a66126011c8339bdad555343a3"

  bottle do
    cellar :any_skip_relocation
    sha256 "5834bc5553c7ac45fcbcba475f882493b296db8938981de8c2f736b255d32e39" => :catalina
    sha256 "a89b8315003be091c6b492d875e1998c96097116ebbd7f4478336932cf814ca2" => :mojave
    sha256 "8a9f96d046fa298eb50a677c1c08a02990726b69d4c0f324b9f001a0bd89df3e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rancher/rke").install buildpath.children

    cd "src/github.com/rancher/rke" do
      system "go", "build", "-ldflags",
             "-w -X main.VERSION=v#{version}",
             "-o", bin/"rke"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end
