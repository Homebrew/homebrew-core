class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.67.3.tar.gz"
  sha256 "10d1a0cc310a83ee50bd9af6a6d3866a5c483de814e340b32d27c81daaf89a7a"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "067e9fbbb0e80cfc102120749cb418c07835fa3679db6a4fe725614d1cd5e9f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6225da91d12b861ff6ba767c303ed2543a26771f544831e6768969a2eaae29d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afbb39f561e05f3d1d8160584fad2ed47c1739905bee1651ae12a3576477eb0f"
    sha256 cellar: :any_skip_relocation, monterey:       "250721420fbce3af49616fd40af99c91fd0cae872c5803e15c349eabbedeac6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ff72c0a69e9c2b280cbb76a15ff0ce22d3ffb5cfd5153f23c07771a6d769fb1"
    sha256 cellar: :any_skip_relocation, catalina:       "362094ad0afae505851092382a194d8e83bb94619f5d327298db8214dce7a807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4d707c5ed7765a30bc75388ed0a86988e7415b41028e97c99a27d69424d0d37"
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
