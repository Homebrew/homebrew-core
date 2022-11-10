class Tart < Formula
  desc "macOS and Linux VMs on Apple Silicon to use in CI and other automations"
  homepage "https://github.com/cirruslabs/tart#readme"
  url "https://github.com/cirruslabs/tart/archive/refs/tags/0.33.0.tar.gz"
  sha256 "66c2b3a0b175344bdb2f9a61c7c34e9be935a7f241b3fd44721fe995852581bd"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08333e5d3e0964bcb2c8a3ca7045a06fa8ab8fa1ae702afd6d6cdb5e1dc8ff13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "258c961a07ed82bd6de6edc6a60a69540299aa0d28644cfeb77e300756a405fd"
  end

  depends_on "rust" => :build
  depends_on xcode: ["14.1", :build]
  depends_on arch: :arm64
  depends_on macos: :monterey
  depends_on :macos

  uses_from_macos "swift"

  resource "softnet" do
    url "https://github.com/cirruslabs/softnet/archive/refs/tags/0.3.0.tar.gz"
    sha256 "b77fb9424cf6a5c61e2a2513a531f0a9321047890979ca7282a5c036ebf48938"
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
    output = shell_output("tart create --from-ipsw #{testpath/"empty.ipsw"} test", 1)
    assert_match "Unable to load restore image", output
  end
end
