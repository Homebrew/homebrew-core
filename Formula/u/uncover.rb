class Uncover < Formula
  desc "Tool to discover exposed hosts on the internet using multiple search engines"
  homepage "https://github.com/projectdiscovery/uncover"
  url "https://github.com/projectdiscovery/uncover/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "b88864edc8832b70135191ea7fbd4b8e89a6acc2a4c923d7382a9413b21016e7"
  license "MIT"
  head "https://github.com/projectdiscovery/uncover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91796fb8db26506fdf1608af91807e13ba23f13196acd8e3dad10f5fb55eb601"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "580f00912964beee231517b5808223df7c30d473a8324e76f6dd1a1a90d7460b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb0bb67117e33995235734fa51d921f7ea30039dd0c166a2fb5706710fee7627"
    sha256 cellar: :any_skip_relocation, sonoma:         "74e0773aac9aac907689317a59a54aa7761b98bb065f2f34d51b90432be4ed59"
    sha256 cellar: :any_skip_relocation, ventura:        "5fd6739975efa0739f824c0a11354c030200617093fc4a86ad7477fc9376b3b9"
    sha256 cellar: :any_skip_relocation, monterey:       "72c4968f8dcb504a319b0c747bffcc93a2553dc387590788ddd10a349cc879c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73455eeed5a1cdc4475a250d46c94fc3981ab9f1c8c3f57e22dc8e5c281c11b5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/uncover"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uncover -version 2>&1")
    assert_match "no keys were found", shell_output("#{bin}/uncover -q brew -e shodan 2>&1", 1)
  end
end
