class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://sonobuoy.io/"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/refs/tags/v0.57.4.tar.gz"
  sha256 "5e84f5e4723879b613688ce70522fc0423e5fbe2ada5c341484a60f295715af9"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d38eeff7e2714c2a329f9028c96692c2c4997bf2772d530672dc893b70235735"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d38eeff7e2714c2a329f9028c96692c2c4997bf2772d530672dc893b70235735"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d38eeff7e2714c2a329f9028c96692c2c4997bf2772d530672dc893b70235735"
    sha256 cellar: :any_skip_relocation, sonoma:        "7520b1997a933d60f51a3ac76778969f722c02d006e26640196b4bfc15a4342d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27202e2a75ff97b252c812426b61c3e16bed22b1e8de258e61c4c222d8056719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1415146262a80affb1f033a826e071437e651d443da8f6df933fc58fe9d2b043"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vmware-tanzu/sonobuoy/pkg/buildinfo.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"sonobuoy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Sonobuoy is a Kubernetes component that generates reports on cluster conformance",
      shell_output("#{bin}/sonobuoy 2>&1")
    assert_match version.to_s,
      shell_output("#{bin}/sonobuoy version 2>&1")
    assert_match "name: sonobuoy",
      shell_output("#{bin}/sonobuoy gen --kubernetes-version=v1.21 2>&1")
  end
end
