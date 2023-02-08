class Tart < Formula
  desc "macOS and Linux VMs on Apple Silicon to use in CI and other automations"
  homepage "https://github.com/cirruslabs/tart"
  url "https://github.com/cirruslabs/tart/archive/refs/tags/0.37.1.tar.gz"
  sha256 "c9ced4b02540e0e3827ac1de19d65ffd74f70715ac9cca92946675309b78f280"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e81e79cb93fda37264efabc6d50ee1bf3feee86d0e4126399302d104ee5680a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4e4e6cfe12b59eab1379b7a22fc0490cd5d0aae78338de1e6c238825e2358c6"
  end

  depends_on "rust" => :build
  depends_on xcode: ["14.1", :build]
  depends_on arch: :arm64
  depends_on macos: :monterey
  depends_on :macos

  uses_from_macos "swift"

  resource "softnet" do
    url "https://github.com/cirruslabs/softnet/archive/refs/tags/0.6.2.tar.gz"
    sha256 "7f42694b32d7f122a74a771e1f2f17bd3dca020fb79754780fbc17e9abd65bbe"
  end

  # patch for 12-arm build, upstream PR ref, https://github.com/cirruslabs/tart/pull/408
  # remove when patch is available in next release
  patch do
    url "https://github.com/cirruslabs/tart/commit/c91e6882e64289838a7bb97fd85ff5ab0b5e1d87.patch?full_index=1"
    sha256 "015e0c25402c34031ed07cf0fe6c5558e139ab7472ecc4f625edab886d51aff5"
  end

  def install
    resource("softnet").stage do
      system "cargo", "install", *std_cargo_args
    end
    system "swift", "build", "--disable-sandbox", "-c", "release"
    system "/usr/bin/codesign", "-f", "-s", "-", "--entitlement", "Resources/tart.entitlements", ".build/release/tart"
    bin.install ".build/release/tart"
  end

  test do
    ENV["TART_HOME"] = testpath/".tart"
    (testpath/"empty.ipsw").write ""
    output = shell_output("tart create --from-ipsw #{testpath/"empty.ipsw"} test 2>&1", 1)
    assert_match "Unable to load restore image", output
  end
end
