class SwiftOutdated < Formula
  desc "Check for outdated Swift package manager dependencies"
  homepage "https://github.com/kiliankoe/swift-outdated"
  url "https://github.com/kiliankoe/swift-outdated/archive/refs/tags/0.9.0.tar.gz"
  sha256 "b6ee31edc45711c6425d047fe1b4f177da2498201dab5d94dbe86d8bd483419c"
  license "MIT"
  head "https://github.com/kiliankoe/swift-outdated.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e51d1646a256b47a32512952ba7fa916f1744b11c3c09ddc3c5a576845ed270a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f64533b814302cc8f16f49ce3af1ffdc261f3c2a4a5659dc55ba70fcc9251472"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f60b56ed944d4428552ab6802d4ed69808eae4c4411223701c3fbcd1cf74d2a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "476390766ef47a7427e44c7292238c009dc5859cdcc8908e99b74cf9516a9292"
    sha256 cellar: :any_skip_relocation, ventura:        "baa8fc055b4b1df5bf20951f476ecd99f657711205508a36591cc1f189baa355"
    sha256 cellar: :any_skip_relocation, monterey:       "b27aeed8749c5062d7a666ca041a77be76bcc785d19446d0007bc7d4d62af3e3"
    sha256                               x86_64_linux:   "4723925318b3bbb4b9d000c519c3e5956fc3bd5073e6315e2be4cbf306b089ae"
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
