class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/vmware-tanzu/velero/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "e292c4427d801b426a53e24cff10aed16de5bcbf2a5207edfee30d8c4d363135"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e0ff8caec98eec0c4d7e95493514c485966559fc798fb6d8d8346890c1238c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e9e8ecd38140f9e644987bea9813d2230cfc188d428a18eb48ee4d744a6445a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89a9f4763bcc6697812b97b3e17bbde0d3b1f65400b111ca3d9da463f9682137"
    sha256 cellar: :any_skip_relocation, sonoma:         "889cecb24d3457c0eee9b24bf1eab74ce8950f8da1843cb8fd603616841472f7"
    sha256 cellar: :any_skip_relocation, ventura:        "43efeee70ae3efd92a8d9fdedad4f1fef71298549b3a29e5a16e1faef317bd7a"
    sha256 cellar: :any_skip_relocation, monterey:       "005a04a88ec90c19dd30d543be767b4e1a32738da80dd14c6e3a8f07e0c0c69f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e0717eca296753715d45bfe1ffd5e046ad7de764350eae9b5e1b8ae3d621aba"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "-installsuffix", "static", "./cmd/velero"

    generate_completions_from_executable(bin/"velero", "completion")
  end

  test do
    output = shell_output("#{bin}/velero 2>&1")
    assert_match "Velero is a tool for managing disaster recovery", output
    assert_match "Version: v#{version}", shell_output("#{bin}/velero version --client-only 2>&1")
    system bin/"velero", "client", "config", "set", "TEST=value"
    assert_match "value", shell_output("#{bin}/velero client config get 2>&1")
  end
end
