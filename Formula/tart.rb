class Tart < Formula
  desc "macOS and Linux VMs on Apple Silicon to use in CI and other automations"
  homepage "https://github.com/cirruslabs/tart"
  url "https://github.com/cirruslabs/tart/archive/refs/tags/0.38.0.tar.gz"
  sha256 "ca6a46c2373eb9c9e105d2a80229f7cbcdb03d5ce800173ec01b78424f5a5d7f"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "321bea92ef4cbd05bf1f85f203391a0a24c311d53f68e8b1bb1d3ab063c2a1e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f18923a7f2d94e0d2d5b53f33da65c099c4537fdc580d97277aefb85c890f234"
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
    output = shell_output("#{bin}/tart create --from-ipsw #{testpath/"empty.ipsw"} test 2>&1", 1)
    assert_match "Unable to load restore image", output
  end
end
