class Tart < Formula
  desc "macOS and Linux VMs on Apple Silicon to use in CI and other automations"
  homepage "https://tart.run/"
  # NOTE: 1.x uses non-open source license
  # https://tart.run/blog/2023/02/11/changing-tart-license/
  url "https://github.com/cirruslabs/tart/archive/refs/tags/0.38.0.tar.gz"
  sha256 "ca6a46c2373eb9c9e105d2a80229f7cbcdb03d5ce800173ec01b78424f5a5d7f"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4dbd3a34414fec476db6ef5cb18ad889546b730e2f9e449ced3e2b14abd5dd30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2938ae8b794f0875409753bc21f34b306e4ee39e73157d28fc2b1407b7bd39c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be32fd68c2c54a9c874b4278ae8599116c1bb74464c1ae94064097839ae64e09"
  end

  # https://tart.run/blog/2023/02/11/changing-tart-license/
  # Original deprecation date: 2024-09-16
  disable! date: "2025-02-28", because: "switched to a DFSG-incompatible license"

  depends_on maximum_macos: [:sonoma, :build]
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
    generate_completions_from_executable(bin/"tart", "--generate-completion-script")
  end

  test do
    ENV["TART_HOME"] = testpath/".tart"
    (testpath/"empty.ipsw").write ""
    output = shell_output("#{bin}/tart create --from-ipsw #{testpath/"empty.ipsw"} test 2>&1", 1)
    assert_match "Unable to load restore image", output
  end
end
