class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.10.0.tar.gz"
  sha256 "d85663f160c2902789194502c036953a856f57d7c0481c23ab12e719a7a21d42"

  bottle do
    cellar :any_skip_relocation
    sha256 "535ec002c95d1fd0c0ee84828d3844ea9845493e55e099941366d004bdfa6b55" => :catalina
    sha256 "c56a08ee17e686bc22a17b9982d5879848660e9472464dfdae3bb7dd0d5b55f3" => :mojave
    sha256 "f19731f06d92e88fe464b72b14457b85230c926e20e5a428e8fcf2500e357fd5" => :high_sierra
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
    io = IO.popen(cmd, :err => [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end
