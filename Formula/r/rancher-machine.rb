class RancherMachine < Formula
  desc "Machine management for a container-centric world"
  homepage "https://github.com/rancher/machine"
  url "https://github.com/rancher/machine/archive/refs/tags/v0.15.0-rancher145.tar.gz"
  version "0.15.0-rancher145"
  sha256 "e039feb0f202854a97737bf7eadfde1d1a647294494c153791d191f8277835b0"
  license "Apache-2.0"
  head "https://github.com/rancher/machine.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-rancher\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2545aaf76aba913bbe20dd34d1f1029de506f8d6df73b296aaf6e58b63e6b259"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2545aaf76aba913bbe20dd34d1f1029de506f8d6df73b296aaf6e58b63e6b259"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2545aaf76aba913bbe20dd34d1f1029de506f8d6df73b296aaf6e58b63e6b259"
    sha256 cellar: :any_skip_relocation, sonoma:        "3338ed79b62e0103e0e6aee587e52efe6a5f5e63674879019a574d2b7c5678d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c27da271c1d0aa6267c8e5640f09bb5d493add89a1768ce9492980aa19005d9"
    sha256 cellar: :any,                 x86_64_linux:  "2d864571c4dadce840efce99a57fc0f98621e80d711e3a5e7f5d18643810adfe"
  end

  depends_on "go" => :build

  def install
    commit = build.head? ? Utils.git_short_head : tap.user
    ldflags = %W[
      -w -s
      -X github.com/rancher/machine/version.Version=#{version}
      -X github.com/rancher/machine/version.GitCommit=#{commit}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/rancher-machine"
  end

  service do
    run [opt_bin/"rancher-machine", "start", "default"]
    environment_variables PATH: std_service_path_env
    run_type :immediate
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rancher-machine --version")
    assert_match "VBoxManage --version", shell_output("#{bin}/rancher-machine create test", 3)
  end
end
