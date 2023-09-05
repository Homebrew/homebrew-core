class SwiftOutdated < Formula
  desc "Check for outdated Swift package manager dependencies"
  homepage "https://github.com/kiliankoe/swift-outdated"
  url "https://github.com/kiliankoe/swift-outdated/archive/refs/tags/0.7.0.tar.gz"
  sha256 "fc2b75aba57966ad3d11613cd482828a79b3b60c00005a557e2a5976d923214c"
  license "MIT"
  head "https://github.com/kiliankoe/swift-outdated.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd29000da36f3352fc8719c7b607394e50c83930045f03b499c66aee21e46b74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c73a4ffa35d10147f6909dc1a263141abf4a6c780f60ca7d00d90f453671097c"
    sha256 cellar: :any_skip_relocation, ventura:        "6e4e498dc6d10ad6b5042d8a351368f7966e8ab7e697499392224b1f966bfcd5"
    sha256 cellar: :any_skip_relocation, monterey:       "0dfff41b3797db49237ee28643fe23a15d626347c0427df32d4edd4680c7bddd"
    sha256                               x86_64_linux:   "01ab6f45381cd1c121c0fdf5d24ebfec244c1000bd8d967e8c3d82e9991b7943"
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
