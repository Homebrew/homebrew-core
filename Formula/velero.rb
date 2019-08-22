class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/heptio/velero"
  url "https://github.com/heptio/velero/archive/v1.1.0.tar.gz"
  sha256 "9313f059c9c973052fba4b307e652b1067b8542302277af1f610415e79cb32c0"

  bottle do
    cellar :any_skip_relocation
    sha256 "05177d006b69e56fd04457380e461ab2a4d666374ff3ca9378aa4e31d7f2c1ca" => :mojave
    sha256 "1625c1559141096d44a6e5dcf6fa5db70f97a19f590139c2f4dd9412452dc4e7" => :high_sierra
    sha256 "5d46e4176b0cb13195150030980e36a7e8a6b15f90f0fd56a9f471b27597ef5c" => :sierra
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
