class SwiftOutdated < Formula
  desc "Check for outdated Swift package manager dependencies"
  homepage "https://github.com/kiliankoe/swift-outdated"
  url "https://github.com/kiliankoe/swift-outdated/archive/refs/tags/0.5.1.tar.gz"
  sha256 "4c8bb4a630b5c3c456ac24e3dfe92f812ac14b2cb0a5e5bd298a4d83abe630ec"
  license "MIT"
  head "https://github.com/kiliankoe/swift-outdated.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f8e5dbbdca6cab1d848c5d9bde479587d0c35dc5c3776dcb9a4fc1874f31776"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09b572ef7569888de46c94fe2fea2870d51eb0873ed6a9ca88b27e7303371f6c"
    sha256 cellar: :any_skip_relocation, ventura:        "8eec0dc9907ea935f31ebca26c8ffc66245cde497358fb178fd665a19e3a74d6"
    sha256 cellar: :any_skip_relocation, monterey:       "69dfa5ab1d820862a225aa5cc27cf5fa19c3310460f2c55bf1b2143e2dd7aeb8"
    sha256                               x86_64_linux:   "c112f2cb35f4345a7b85cb4213005b0ed017d1e429de7799d2c56eef8bc67bfd"
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
