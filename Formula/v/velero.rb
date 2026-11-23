class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://github.com/velero-io/velero/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "789f13190b0d35a8edadddfb7dfb442236f2e2699c6a78b1d3fd45da7c7957c1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "bf04c869cd8419cd13610384d62f8ff0ab80366e1047bbbac960a147ba4c2c15"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7685fd2ced2e61d6e1bc092113e9deaa8b869a18406bdae576652d0d16df100c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "65c6c4398cb94ec0c32fd1254b580a1f8cb3233d8bdf559fa859bcc3f99d7e81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2aaba1fc2ef71436e3ece456954244a91c3fae99a1afc067136731cb01345763"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8707aa01e1a6dee65ace712f01e6fe2814c01f6b82cfc9aca267684ffb72c786"
    sha256 cellar: :any,                 x86_64_linux:      "dd93ef8185df5ccc71e03cdcaac7aa05c20374b881c5ac81ce494f965724682a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    commit = build.head? ? Utils.git_head : Utils::Git.get_tar_commit_id(cached_download)
    ldflags = %W[
      -X github.com/velero-io/velero/pkg/buildinfo.Version=#{version}
      -X github.com/velero-io/velero/pkg/buildinfo.GitSHA=#{commit}
      -X github.com/velero-io/velero/pkg/buildinfo.GitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "-installsuffix", "static", "./cmd/velero"

    generate_completions_from_executable(bin/"velero", "completion")
  end

  test do
    output = shell_output("#{bin}/velero 2>&1")
    assert_match "Velero is a tool for managing disaster recovery", output
    assert_match "Version: #{version}", shell_output("#{bin}/velero version --client-only 2>&1")
    system bin/"velero", "client", "config", "set", "TEST=value"
    assert_match "value", shell_output("#{bin}/velero client config get 2>&1")
  end
end
