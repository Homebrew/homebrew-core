class WxCli < Formula
  desc "WeChat 4.x local data CLI with daemon architecture"
  homepage "https://github.com/jackwener/wx-cli"
  url "https://github.com/jackwener/wx-cli/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "de8ed8208d8b0af7c2fb93414f35f9816cbafdf654cb969f93bd374a87c8fe35"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b817528ff5a05e6973dc952859b07d501766e9918cc42d2966d12dfcd0e4049"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa6081b612cd39b29a29990b0fe5cdd7c21ba681000f16301a78cd2ed981eda8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29b50cedb0e7d19ed0e55bd208705f5577abff98931d02aa1feb4c47327ad9b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "89eb31df09f7a7375c0326c5bf42e3a2b88f34bf02abe320fa478ce733333814"
    sha256 cellar: :any,                 arm64_linux:   "c8ba8710e4be87e4afffb3908dc6573061d9f14cd93d40dcd3af3e745ce3ede4"
    sha256 cellar: :any,                 x86_64_linux:  "b0741780081ff08ed00f9a44f4a43748d534a77324d447080bc3113bb1612bca"
  end

  deprecate! date: "2026-07-17", because: :repo_removed
  disable! date: "2026-10-17", because: :repo_removed

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wx --version")
    assert_match "wx-daemon", shell_output("#{bin}/wx daemon status")
  end
end
