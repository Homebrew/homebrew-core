class Stormy < Formula
  desc "Minimal, customizable and neofetch-like weather CLI based on rainy"
  homepage "https://github.com/ashish0kumar/stormy"
  url "https://github.com/ashish0kumar/stormy/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "ade8136120b6245f449b645179333e31c0fcd11faf20a10506c6b8c2e11eb8e9"
  license "MIT"
  head "https://github.com/ashish0kumar/stormy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "687010ca1018c80b732cbf1b35a9350db39a2a2ad20dec22056c67ccf910894b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "687010ca1018c80b732cbf1b35a9350db39a2a2ad20dec22056c67ccf910894b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "687010ca1018c80b732cbf1b35a9350db39a2a2ad20dec22056c67ccf910894b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1aad754bb1d81cbb4a714e0117204ad6e5dbe34c971ea438202a595eb8d8655d"
    sha256 cellar: :any_skip_relocation, ventura:       "1aad754bb1d81cbb4a714e0117204ad6e5dbe34c971ea438202a595eb8d8655d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b16e184e0b5a4a5a82776f5af8e0184d0c40ac648cdf65a1099828b3c57144a6"
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
