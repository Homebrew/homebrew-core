class TfSummarize < Formula
  desc "CLI to print the summary of the terraform plan"
  homepage "https://github.com/dineshba/tf-summarize"
  url "https://github.com/dineshba/tf-summarize/archive/refs/tags/v0.3.14.tar.gz"
  sha256 "c4ea4825aef3bb393917aaa97beec66a07e58890229bd4832f719b1dad4f449e"
  license "MIT"
  head "https://github.com/dineshba/tf-summarize.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b4f564bd9474540f43c55132f62fe1c77030303ff0c96c2f89f95d5ba1165ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49d532560bc3caf6e781226c2f9559532f8f73bf1132664b36b97883f2573ad5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49d532560bc3caf6e781226c2f9559532f8f73bf1132664b36b97883f2573ad5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49d532560bc3caf6e781226c2f9559532f8f73bf1132664b36b97883f2573ad5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6850383b616f89461bf37cd0389bd0fc9bf2d79f41cd490e3e19166b1c09171"
    sha256 cellar: :any_skip_relocation, ventura:       "b6850383b616f89461bf37cd0389bd0fc9bf2d79f41cd490e3e19166b1c09171"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50127b7d075bc6873c2802e2882c1e4c4b87802f7e9faa464e188c97d4ad2361"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7984edfb50bba79f2729f8d566314c0cdf95f3d648d63472738210773f6c0c89"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    resource "tfplan.json" do
      url "https://raw.githubusercontent.com/dineshba/tf-summarize/c447ded989b8e84b52d993e0b0e30139b5fb5818/example/tfplan.json"
      sha256 "ceca61c72c77b4400d4170e58abc0cafd3ad1d42d622fe8a5b06cdfba3273131"
    end

    assert_match version.to_s, shell_output("#{bin}/tf-summarize -v")

    testpath.install resource("tfplan.json")
    output = shell_output("#{bin}/tf-summarize -json-sum #{testpath}/tfplan.json")
    assert_match "7", JSON.parse(output)["changes"]["add"].to_s
  end
end
