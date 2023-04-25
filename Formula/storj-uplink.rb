class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.76.2.tar.gz"
  sha256 "7987191edecff53da2560b00d3b11e6c63e479e1bbbd90ce37ad491ac4ed2ce2"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38238785fd9f2520ed14abd0b4406893ecff665936c898eb51ff7d123489db96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1099ddef366084e9d76807088811bfe6435b714147e44a9521fe998944b2b218"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f15b0a08f8210533d11ccc43c44111fbbb271ca11ecbdb4a63a4fa8787d0384e"
    sha256 cellar: :any_skip_relocation, ventura:        "383e4b68bafd25ef53a1aaff21a888c0f287f965168fae4c0d34d5d5807888cf"
    sha256 cellar: :any_skip_relocation, monterey:       "091fbe6cad4e6851f21114e0c0178f3a12863bfcbb14bcbf2084805972c7e1dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3a23ccfed98610ee6819eb12aad6c2fd268069a554e83969c74e0bf91be925a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a4f2b498690fc05c9ff194dff54511a83c7b72d93d3b7972c1b58dedd4b2f9c"
  end

  # Support for go 1.20 is merged upstream but not yet landed in a tag:
  # https://github.com/storj/storj/commit/873a2025307ef85a1ff2f6bab37513ce3a0e0b4c
  # Remove on next release.
  depends_on "go@1.19" => :build

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
