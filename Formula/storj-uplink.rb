class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.50.4.tar.gz"
  sha256 "8f507ffa4bf70eeeb3cf9dc5c4e7794c9913354495d497bdd1d1cdb2b8453fe5"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24661138ae188ab1ca55e5a1ed552df4d9c0411f0db7e004f0b04ee4b2b5dbb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe5228829a136681027362b9deb96697afe2c43178c2c5c01b9344e8d58fe719"
    sha256 cellar: :any_skip_relocation, monterey:       "f3da90c0dc7b02c1e78d579825533c040817219945128353e49b7ddb8684687b"
    sha256 cellar: :any_skip_relocation, big_sur:        "19d11124c53bfeb064259003ca6150d9f38bbc8536a8b7248256a6b113098be0"
    sha256 cellar: :any_skip_relocation, catalina:       "2b77cf8d19b89d645fa11044e8d495b0a53d2329da12979aff99f36454aeaefe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb866788f2ee8a4d177788ddc7a259c321e74e4b3ef565e5757df4cf998b55a6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-o", bin/"uplink", "./cmd/uplink"
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
