class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.86.1.tar.gz"
  sha256 "875e99ef2bc1aa61ead18645166cea366ba458e69f6003873e21961e11b997db"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f27305bb187bf1ffe0d60c165b2a9cca3e4e133de3ceb611a8d40de6be7f83d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f217ea0a15b47df819e1feb3683f2ce0f7b4e33aaa8cc5e174c64b9e4e2b184"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a30f380c74461d1766acd722d553414c13bf4cd96e60272d6b844bbd35731ba"
    sha256 cellar: :any_skip_relocation, ventura:        "f1d98257c7b3569d6380cbcde71e241b9a4a0c6584025573f61ae7682d2ca33f"
    sha256 cellar: :any_skip_relocation, monterey:       "988b33048b00d30cd0f82bcd527b6f7d36f09e7e09537d73059ea5af9c4eaa3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "81d08ce749eadbdd9516fea0ff352840c2488e170859e733c918cf84e523add0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bc0d5231aefd66bae8b13fc16faeaadeda2a6bac0ff907a1ce5ff7ed7da5a9d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
