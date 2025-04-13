class Tgpt < Formula
  desc "AI Chatbots in terminal without needing API keys"
  homepage "https://github.com/aandrew-me/tgpt"
  url "https://github.com/aandrew-me/tgpt/archive/refs/tags/v2.9.4.tar.gz"
  sha256 "d0b6456abe421002d9380e9f8a901d833ad8b78d5ab3aa60b862e116a1aacbb6"
  license "GPL-3.0-only"
  head "https://github.com/aandrew-me/tgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2aabd23fda12cfa0fd5379e470a344f559723a2b8a69b192c5fa21f920df62ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2aabd23fda12cfa0fd5379e470a344f559723a2b8a69b192c5fa21f920df62ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2aabd23fda12cfa0fd5379e470a344f559723a2b8a69b192c5fa21f920df62ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "f667a48a081576568285679ab2ee68595e88ad5531d4b75952e630ef0f98e492"
    sha256 cellar: :any_skip_relocation, ventura:       "f667a48a081576568285679ab2ee68595e88ad5531d4b75952e630ef0f98e492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba565ff50cb71209a404802e564bb319317b7c80f82b6a29b7dbe2e206fb8cd2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tgpt --version")

    output = shell_output("#{bin}/tgpt --provider pollinations \"What is 1+1\"")
    assert_match "1 + 1 equals 2.", output
  end
end
