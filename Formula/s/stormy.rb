class Stormy < Formula
  desc "Minimal, customizable and neofetch-like weather CLI based on rainy"
  homepage "https://github.com/ashish0kumar/stormy"
  url "https://github.com/ashish0kumar/stormy/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "b53d479643599c733090ebf54eebd582eb3fe5faf5148015770f0ab594dc6464"
  license "MIT"
  head "https://github.com/ashish0kumar/stormy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67985bd5741387e48074e5ea65d239509ea4474a1a5d81c613772eac32d5df34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f5afa7f01c4edb5cc517ce4526a3a406b68137f228168d2210f035844d0858b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f5afa7f01c4edb5cc517ce4526a3a406b68137f228168d2210f035844d0858b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f5afa7f01c4edb5cc517ce4526a3a406b68137f228168d2210f035844d0858b"
    sha256 cellar: :any_skip_relocation, sonoma:        "736f0c364525cc53e357beede4b8c7688664fd0f89044e8b05b9d248376ebdd3"
    sha256 cellar: :any_skip_relocation, ventura:       "736f0c364525cc53e357beede4b8c7688664fd0f89044e8b05b9d248376ebdd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62c64a85488c29dd54fac3f317313479a551254db1771a0133dca1f007904323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42244149b73dcd15de4070a2e282295a93fa36766da806e1d3e7e138eede3800"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Weather", shell_output("#{bin}/stormy --city London")
    assert_match "Error: City must be set in the config file or via command line flags",
      shell_output("#{bin}/stormy 2>&1", 1)
  end
end
