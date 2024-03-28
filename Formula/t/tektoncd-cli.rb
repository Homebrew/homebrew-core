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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca050e6ae7faadc740624591dc25a5cb9028e4cee89ba6eeca4087adaea03bbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2e26dbd2ae7e8dc77ca96b2feca3537fa6818d83e222d2d8c236922e7773815"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07a02dff635d61973a6b9265d249b4920aefb6c45f4f1ab827b7c18aa1167bf1"
    sha256 cellar: :any_skip_relocation, sonoma:         "d26a23ad5492c9d371504b6357de027c7910c619d256701be083b4238fca7785"
    sha256 cellar: :any_skip_relocation, ventura:        "450888141041a6beaaaa39b7504d9208662d936fe15a5ec3236ad5340d64a254"
    sha256 cellar: :any_skip_relocation, monterey:       "dd8de62a84df18f1b7878b964105f46f7c7a5f56f928c748f295479456903051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3f22cbb48dbcac62d72b138f147c81b4e3a1bbe16d8c91304eec73c926ededd"
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
