class RancherMachine < Formula
  desc "Machine management for a container-centric world"
  homepage "https://github.com/rancher/machine"
  url "https://github.com/rancher/machine/archive/refs/tags/v0.15.0-rancher146.tar.gz"
  version "0.15.0-rancher146"
  sha256 "82e6f182eb9a91bfad581a09c4f1747477127ce13164114d32894afdaa185459"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/rancher/machine.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-rancher\d+)$/i)
  end

  bottle do
    manifest_sha256 "4439ed9d7462e2a19ac6f016938c96ade6a5d1b8d9af8b9d37019e0a1ef889ff"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "738dd03ad2a6c863e89484959e1ba984a367358b2ab7212ab92d493a3d483684"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "738dd03ad2a6c863e89484959e1ba984a367358b2ab7212ab92d493a3d483684"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "738dd03ad2a6c863e89484959e1ba984a367358b2ab7212ab92d493a3d483684"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bbaa4e1b57cedd0ba00b5087526a89fde14f94b7f64f23291afcd7e0a3b498cc"
    sha256 cellar: :any,                 x86_64_linux:      "29994ec618046fd986e59288eb8d78535ca8b60c96295fd46c2b3b21971c7186"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    commit = build.head? ? Utils.git_short_head : tap.user
    ldflags = %W[
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
