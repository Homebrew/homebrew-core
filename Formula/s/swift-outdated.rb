class SwiftOutdated < Formula
  desc "Check for outdated Swift package manager dependencies"
  homepage "https://github.com/kiliankoe/swift-outdated"
  url "https://github.com/kiliankoe/swift-outdated/archive/refs/tags/0.8.0.tar.gz"
  sha256 "40f678b9fb2403b37f76499b9e25f409f20eeb1f647cf13d58bca96ffb3564c0"
  license "MIT"
  head "https://github.com/kiliankoe/swift-outdated.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d8b30468fd17e0d99ea4a343ae298b9e4c62102cf0edb451d0640a05a7c52d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ec29ec9524e3321d3da25c10b1a2a46f37afc9abc79e4afac5aacc250101e10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cdc7150c1fc3c3e56d549b34d5766953fdb25b239110d1d95e614aa6a7e9364"
    sha256 cellar: :any_skip_relocation, sonoma:         "f578022275d94fa7a9dbafbfba9454474f1aa7532638db23d36f45f061bafdb4"
    sha256 cellar: :any_skip_relocation, ventura:        "954d2665019bbda5f6dfe7346156be72a9d3573734602eda79110eec2f68cde3"
    sha256 cellar: :any_skip_relocation, monterey:       "1b5c4670a2d42b03a4695f53954f8ae3c130ca1e463322c599f52b2227374669"
    sha256                               x86_64_linux:   "c277c7a03a81af13fad593ad0f124613e9e08c55759f1c9345c3cb56017e155a"
  end

  depends_on xcode: ["13", :build]
  depends_on macos: :monterey

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/swift-outdated"
  end

  test do
    assert_match "No Package.resolved found", shell_output("#{bin}/swift-outdated 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/swift-outdated --version")
  end
end
