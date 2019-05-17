class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/heptio/velero"
  url "https://github.com/heptio/velero/archive/v0.11.1.tar.gz"
  sha256 "9d8658f3b7826ac29cac87fe343569deb8c3aa7623fb41e8c15aa3b2659f0d4c"

  bottle do
    cellar :any_skip_relocation
    sha256 "aeeca4f1b88dd509811dbe7b833852765439db2b6b450b489a4718d4a9f93659" => :mojave
    sha256 "972e4e0e4867d5f707c56f78544bb632785b9f174493cfda6bbb6bfe0c8b5993" => :high_sierra
    sha256 "a0875cee2f5b7d07cab5c3cca74f86ed5973dc1f297e1f6faabbc14d26ed14d7" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/heptio/velero"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "go", "build", "-o", bin/"velero", "-installsuffix", "static",
                   "-ldflags",
                   "-X github.com/heptio/velero/pkg/buildinfo.Version=v#{version}",
                   "./cmd/velero"

      # Install bash completion
      output = Utils.popen_read("#{bin}/velero completion bash")
      (bash_completion/"velero").write output

      # Install zsh completion
      output = Utils.popen_read("#{bin}/velero completion zsh")
      (zsh_completion/"_velero").write output

      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/velero 2>&1")
    assert_match "Velero is a tool for managing disaster recovery", output
    assert_match "Version: v#{version}", shell_output("#{bin}/velero version --client-only 2>&1")
    system bin/"velero", "client", "config", "set", "TEST=value"
    assert_match "value", shell_output("#{bin}/velero client config get 2>&1")
  end
end
