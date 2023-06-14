class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.31.1.tar.gz"
  sha256 "883c0d979511f8cb895743eb0105558762930cd6b2454bf332120883e76d9889"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aab3f2ec8df148a4f048475e6167cfada5a9ef492dc6a608a789a4154e5f4569"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f47cfb210c2dc36cfae0deb75f47386e299875d3a0fba15963733e251d0ce25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bc3080974a3161f5147f276055422312b4b69294e7249dd2023e3dc7359d389"
    sha256 cellar: :any_skip_relocation, ventura:        "51360facc9ed946270816469ebea927fc7f0e5be9349ee5710f6213bf19d58f0"
    sha256 cellar: :any_skip_relocation, monterey:       "0f090704985f7973ea945dfbd45166e9d047153506c7686fd5463be2710af022"
    sha256 cellar: :any_skip_relocation, big_sur:        "35c997a817a4c49bc26ac20d40d0aae4b0a9a9992ea805f661016e2553439dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b21f8509f1bf1678756bd0e781705f80c84d8e1f7d0b1361ed8a2574072d991"
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
