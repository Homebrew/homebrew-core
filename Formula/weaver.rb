class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.1.2.tar.gz"
  sha256 "9052999a85249a5f46fbe7af97c73eb4c93b658dc69444e90ddfefc344665ee4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff3baa7aaccd5664e391032d72c2e0aa714d5c14809ca499f0abca82fbe791e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a51afad4f2c57873ac40f27250b6ac8c72796eb3e64780f97ab7e8f97be40e8"
    sha256 cellar: :any_skip_relocation, monterey:       "164c3300fb9dc8eb1056804b9d1703e14aa7af606a7e2ae3bd15adffddbd3998"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d66f81f2b234e28776e0d7e01763b53bf52c5c59fa8a3a1d9948560d0c3728a"
    sha256 cellar: :any_skip_relocation, catalina:       "13457fdd41255eaa5ee7a9b1a46d00a7eab9b3f62c705e20371f266b480bec59"
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
