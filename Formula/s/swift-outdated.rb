class SwiftOutdated < Formula
  desc "Check for outdated Swift package manager dependencies"
  homepage "https://github.com/kiliankoe/swift-outdated"
  url "https://github.com/kiliankoe/swift-outdated/archive/refs/tags/0.9.0.tar.gz"
  sha256 "b6ee31edc45711c6425d047fe1b4f177da2498201dab5d94dbe86d8bd483419c"
  license "MIT"
  revision 1
  head "https://github.com/kiliankoe/swift-outdated.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56a726e5f73cfc65075dfb810e92cd9b75721bacc4a5c4ac824b7725345baf56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cba510240616bdc16f3c756002a8bbb5368753b2a58d1edfb86b95876d5ac0e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02ed4a34e55f8078b31d691593855fae0e42b8e3605050c6ff0e3ee2ffd21f73"
    sha256 cellar: :any_skip_relocation, sonoma:        "632eac750a169e76150a4f5c304cb2a0fbb71ffd29780fcfa9eb397766af775f"
    sha256 cellar: :any_skip_relocation, ventura:       "c7831671b39aee111e79ac7c31f40f68c58c5d02286ff4d52e9ab5112a4d2f02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd55e79daf1746c15dd34741f33021135c77138d0a72cb58ce10338ee1a10d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c59bab3634d884340765c698e24977dbe5edc9f405dbcbcb97c017014ba05db0"
  end

  depends_on xcode: ["13.3", :build]

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release"
    bin.install ".build/release/swift-outdated"
  end

  test do
    assert_match "No Package.resolved found", shell_output("#{bin}/swift-outdated 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/swift-outdated --version")
  end
end
