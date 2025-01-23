class Uncover < Formula
  desc "Tool to discover exposed hosts on the internet using multiple search engines"
  homepage "https://github.com/projectdiscovery/uncover"
  url "https://github.com/projectdiscovery/uncover/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "21da033571b5f726b22bbe7146cc334ca32b76ae4d39cb43066565ec3d38c3f1"
  license "MIT"
  head "https://github.com/projectdiscovery/uncover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bf50c7caa21e2c32631b723fdf73eff65ac98d1213fcbcc2350d3c9d39be5bdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b99ac4fa55dffd880206929630abc2755c282c9fa1445ff95429321e7eeb60f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18c1721e4c516753727c64d3fe64e00c37a287da791f4a0c4de0581598100ae8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de26a7df9ae03999cdaf0159c5a72f6faaa477239478f591596c7f125e9f96c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "265a89787b78a1a13630d6881c88386b5930b33c37bbf91ab2bf7fb42fea4f11"
    sha256 cellar: :any_skip_relocation, ventura:        "99c1cace80bc709fb90f21eb82c53cf190e2bed766f27cde0a3de643689c339c"
    sha256 cellar: :any_skip_relocation, monterey:       "185eee6fea59b74b83f5eab5e05ab1e106cb9f5cf1168e40427c4a903927409a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c335651058751513043128d93159c82ec19c72250ab3f79f84197c0a795a230"
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
