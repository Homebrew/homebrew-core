class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.17.2.tar.gz"
  sha256 "44444e0ebf02934e500c0806b53cea4269deeaa2a4b04e05d6a74e7bc169ca5d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a8803334ededf8c39be7fea6af6917e7fc56a99d397f102aae0d9d4927de4b69"
    sha256 cellar: :any_skip_relocation, big_sur:       "f1fde128ff114c265b568b649e733b10e5c258ef276f70dc0777ff018784e4ad"
    sha256 cellar: :any_skip_relocation, catalina:      "cb1f5ccce6bf3b29447169c281f5676af292f948aa896a66a50de57229ffd3da"
    sha256 cellar: :any_skip_relocation, mojave:        "b939f79966a491dc00645fa709697aabeb3058dcfd2b0762cffc226287e920cf"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"

    bin.install "bin/tkn" => "tkn"
    output = Utils.safe_popen_read({ "SHELL" => "bash" }, bin/"tkn", "completion", "bash")
    (bash_completion/"tkn").write output
    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, bin/"tkn", "completion", "zsh")
    (zsh_completion/"_tkn").write output
    prefix.install_metafiles
  end

  test do
    cmd = "#{bin}/tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, err: [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end
