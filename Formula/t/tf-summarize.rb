class TfSummarize < Formula
  desc "CLI to print the summary of the terraform plan"
  homepage "https://github.com/dineshba/tf-summarize"
  url "https://github.com/dineshba/tf-summarize/archive/refs/tags/0.3.16.tar.gz"
  sha256 "b37b702a4eb449d913bbfe7db59039b612bbbc3e508af59facfc6ce0207c714b"
  license "MIT"
  head "https://github.com/dineshba/tf-summarize.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f832b5acedb7ea1ff92bc80ee1db289e083551d0bfbf511760c683638f31e8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f832b5acedb7ea1ff92bc80ee1db289e083551d0bfbf511760c683638f31e8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f832b5acedb7ea1ff92bc80ee1db289e083551d0bfbf511760c683638f31e8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cdd577e308d994eb61473cd85d55d24d772d252a5dfc9b290ed06d7a29d1cde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cab8d9bf88c2723ed372158d526b7ead12c05bb06aaf114c5e8b18700ab89bcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b450e8e9aa2485edaa4fa1fe20bdb4605c227cb536e2c589db05a22e98882fba"
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
