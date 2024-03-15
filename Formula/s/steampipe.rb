class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "d91ae2dcbacd001903feb92bfc89b5efbe8c9ec284be8a32eb2e3cf674a7e562"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2aa0ab8fabd5d072c3b21790660cc3cb6dcb824f66ecc70615c18d79beea828c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e9a2c6110985c8621dd853efa92e26d0c5bcaac400427848f5fbac41756fcb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0664a014f91ed3fd7550ad76e8596496682c69d5152feb21d4fd2bc1b57b31e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "08cc4b0280d050b79a0e64b357a55096812b1cff702064557369001839d14a3c"
    sha256 cellar: :any_skip_relocation, ventura:        "c659136ef858663111149b4bef0b3a583cb6f61c427ad07d3387063dbed18fa2"
    sha256 cellar: :any_skip_relocation, monterey:       "1fc6af042af311e66f991b382bbd6f2d0aa9c2382caf5b7f42fd72bd29b39204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dbed4ee18a71667173e4ff7195c76f474f0c111f67fc7c1b9300db6b3a2f2d2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create sample workspace", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
