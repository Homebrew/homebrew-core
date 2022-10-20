class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.27.0.tar.gz"
  sha256 "f6da1fe30c77eedef1ecc1dfd53fe3b64d959e753d07a2a24b383fd637ca1367"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb2614610dd8a9e3b9199da4dea8853709a84cd595b09e3e2bf991c5a873c0fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14408fcc556e343c45de6fb6bcd2d42f8c18350aba0754bff3e9e8d66746b453"
    sha256 cellar: :any_skip_relocation, monterey:       "1afac665a59dcd8be3aa2e9f05c6f5431c265db55cbf80f4a3340470b90e1362"
    sha256 cellar: :any_skip_relocation, big_sur:        "47b6f38eae0bed79c637ebc643e2cc0994a509629e559b4f6bef1be175f0b970"
    sha256 cellar: :any_skip_relocation, catalina:       "1adbe76b539642656d0aa99ac3d24f6523c6516c55e155e4fe46e536149c3798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0a055598cb90d8196f6544ed76a79fd80b7177183477c6c5f1d742bbebd0c07"
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
