class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "dd81c791a556dd883221de853f2c75ca722e78676f9091a2a1382f252b130427"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e6f6e9af15468489109466ee893c3736467a7733820914f8cdd040f96d4050f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dadddc8c5c027ddf8cad2b6e6d7b87dd7de2e90c84a6250db9ec5c0e4549c12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4632ffa45bfb224860fb212da35215167629287e2606e028ca30d79fedd56907"
    sha256 cellar: :any_skip_relocation, sonoma:         "d002753b1f6c10728497ea95450b58f7f7b5a3d4958b65ecc735822424091955"
    sha256 cellar: :any_skip_relocation, ventura:        "d570af93a1de3c73b3214324f832652b4d8d58c665b26e4087d6c63051f8d388"
    sha256 cellar: :any_skip_relocation, monterey:       "295996bf3624a136c759884aef3fb6189475cb67ea4f3e760e0c475a5fbdee36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d216086ba6f46ca885f7a084ba7ac6c61b788d85ae7092c9ea4db5afe2529ce"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    generate_completions_from_executable(bin/"tkn", "completion", base_name: "tkn")
  end

  test do
    cmd = "#{bin}/tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, err: [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end
