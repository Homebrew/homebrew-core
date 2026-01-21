class Uncover < Formula
  desc "Tool to discover exposed hosts on the internet using multiple search engines"
  homepage "https://github.com/projectdiscovery/uncover"
  url "https://github.com/projectdiscovery/uncover/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "367e569a7b1d1be00b5b6b36b9e9853287828bedb0673d255d314e9d54c24a00"
  license "MIT"
  head "https://github.com/projectdiscovery/uncover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea9ea0ffed86c7e1f3bd9a2215f31a999e1b616c54e78da163b0dba5f8a765a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e4e7345d608181e9a46be28d8bd1806b0b1bd2be76db6ecac24faad56b55c91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50344b743a7fd9671ec288d67b57e255a10a2fa4f66ed7237891e85373c05526"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbbda4fa9e7915c6d328108ae8b4aef5425edac92fa70fd625e462451216c65d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75a201de1cc4cd972b6c514697b6af509e05d814754c1aedaea3a79a4a983cec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "096d2093ff8fd12661e40f4ed15b79330762f1864dcd170e2a0d1cf319ee0cbd"
  end

  depends_on "go" => :build

  def install
    # upstream pr ref, https://github.com/projectdiscovery/uncover/pull/707
    inreplace "runner/banners.go", "1.1.0", version.to_s if build.stable?
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/uncover"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uncover -version 2>&1")
    assert_match "no keys were found", shell_output("#{bin}/uncover -q brew -e shodan 2>&1", 1)
  end
end
