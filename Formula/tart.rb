class Tart < Formula
  desc "macOS and Linux VMs on Apple Silicon to use in CI and other automations"
  homepage "https://github.com/cirruslabs/tart"
  url "https://github.com/cirruslabs/tart/archive/refs/tags/0.37.0.tar.gz"
  sha256 "9f2d4af148107f8fed38af0973fcfa6cf3a9b31bab529da8d89ada49f789d519"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5b07783ecae638e17c78cd92e8cc0d3ca06c80cf4175386cba0c508f2fad806"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bf13b206521d4818c8e37367e7a2f3a773c4dae6fe896a6a420c4eb5698f944"
  end

  depends_on "rust" => :build
  depends_on xcode: ["14.1", :build]
  depends_on arch: :arm64
  depends_on macos: :monterey
  depends_on :macos

  uses_from_macos "swift"

  resource "softnet" do
    url "https://github.com/cirruslabs/softnet/archive/refs/tags/0.6.1.tar.gz"
    sha256 "3943295bda70f0520dca9adf469f921f65ec2f6d96240046995dd5528deade57"
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
