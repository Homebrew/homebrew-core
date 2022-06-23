class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.1.2.tar.gz"
  sha256 "9052999a85249a5f46fbe7af97c73eb4c93b658dc69444e90ddfefc344665ee4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bae6a89f59feba501a075d7f48a0b32ae385b106df66793baba1838695d732cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99b16b5bf2dd181ab6e35f7a96eb1a9ad3775366bca9895ca56c9060561a8926"
    sha256 cellar: :any_skip_relocation, monterey:       "2fde9ffc9b72493738d043957179600963f9b1603b6e97e5600f5f0f296f7291"
    sha256 cellar: :any_skip_relocation, big_sur:        "e154014fd74e68b6dcb59b67c74c77a5805418051d958ac1a195b137de13516f"
    sha256 cellar: :any_skip_relocation, catalina:       "98cc42d88e8e5636b17b2c7fda0752d79cae33ed0df3e010997d8418c4f99add"
  end

  depends_on xcode: ["11.2", :build]

  uses_from_macos "swift"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Weaver uses Sourcekitten and thus, has the same sandbox issues.
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system bin/"weaver", "version"
  end
end
