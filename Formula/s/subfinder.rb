class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "90337a91df2924ee385ca048862643d1daab6c7d81ddda66d58e6c100df3ba2d"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d64760336155d22c5ef72eeb907dc73969992cc9d5f86fb68f5fb9f5d3553f64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e1ae86daad76d90829041cc7d826808def24abbbfe148dc5b0780df3a61e1b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "844e40d933ab2a261aae0deec7e20b53e52e9ed735742cbb5586cdc5e2e99690"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e2039c4056b2893d3de6557a113c33c53f5dd34e9e89e3a8a260d7337350589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f431031aea8794558f1bd04e41e399cf017ad0eb180a4d20bab4fde6fddd6284"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/subfinder"
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")

    # upstream issue, https://github.com/projectdiscovery/subfinder/issues/1124
    if OS.mac?
      assert_path_exists testpath/"Library/Application Support/subfinder/config.yaml"
      assert_path_exists testpath/"Library/Application Support/subfinder/provider-config.yaml"
    else
      assert_path_exists testpath/".config/subfinder/config.yaml"
      assert_path_exists testpath/".config/subfinder/provider-config.yaml"
    end

    assert_match version.to_s, shell_output("#{bin}/subfinder -version 2>&1")
  end
end
