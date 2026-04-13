class TfSummarize < Formula
  desc "CLI to print the summary of the terraform plan"
  homepage "https://github.com/dineshba/tf-summarize"
  url "https://github.com/dineshba/tf-summarize/archive/refs/tags/v0.3.20.tar.gz"
  sha256 "e2e6d173581109e155e86690738a85780947d886c7c3236187467ff2174f62b1"
  license "MIT"
  head "https://github.com/dineshba/tf-summarize.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2334652999366aa46838b87e1f3f5f2a07130a26268707f29898fe216e4bbef6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2334652999366aa46838b87e1f3f5f2a07130a26268707f29898fe216e4bbef6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2334652999366aa46838b87e1f3f5f2a07130a26268707f29898fe216e4bbef6"
    sha256 cellar: :any_skip_relocation, sonoma:        "58861206aaff1656dcf4ce76441d734c233ad6a30742edc2e4eb39b001a5fd04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "748e71928987b8a3dc5a2bb6917de52ad01637b66eb08a748f2565f0b249721f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e06d54a3fa8a91d5a9e3e006ec589d0f2fb9c8be2236b5ca39a7c713ee20dccc"
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
