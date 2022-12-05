class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.68.2.tar.gz"
  sha256 "024629df45fb7434c790b88f1908dab4af69aa19f02cf1215da57947e02814ee"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9711161a44fc5951ec94e36ef6596f446f0a8e967fc40c94b1e46a8d4bfb2468"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "252720d84696221338c3da72aed4dae4678aa1b1310ce6711f870c40485c8bc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "670cd86cb148767eac1a29e86fef5b4453af58b78d496422c669b2c99e6c10a6"
    sha256 cellar: :any_skip_relocation, ventura:        "cbc255eca6c6a76b3abf2d7d352ac985d51443486cbf999bb7d31887f09119aa"
    sha256 cellar: :any_skip_relocation, monterey:       "503f800928a00260e6f0a91afdfda553a17ba942cbbc13c945a338adeb67b753"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea4ac354f01971d979d6dd3df3a4b10ba8444175e9fa5a6bfb185cee794d68bd"
    sha256 cellar: :any_skip_relocation, catalina:       "8032f679b9557b2b12ca8c0cfad03c7d470509488a72b23a957d30570588b23f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a4b015e84854a504ba887bc534e741de43e4467c8b98b78f53f0c22a383fbb8"
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
