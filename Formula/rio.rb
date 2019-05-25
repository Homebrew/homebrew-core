class Rio < Formula
  desc "Kubernetes based MicroPaaS"
  homepage "https://rio.io"
  url "https://github.com/rancher/rio.git",
    :using    => :git,
    :tag      => "v0.1.0",
    :revision => "5edeac11b52dc18364c8a130188e936dfbd6eb14"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/rancher/rio"
    dir.install buildpath.children
    cd dir

    system "scripts/build"
    bin.install "bin/rio"
  end

  test do
    run_output = shell_output("#{bin}/rio 2>&1")
    assert_match "rio - Containers made simple, as they should be", run_output

    version_output = shell_output("#{bin}/rio --version 2>&1")
    assert_match "rio version v#{version}", version_output

    run_output = shell_output("env KUBECONFIG=#{testpath}/non-existing-kubecfg #{bin}/rio install 2>&1", result = 1)
    assert_match "can't contact Kubernetes cluster. Please make sure your cluster is accessable", run_output
  end
end
