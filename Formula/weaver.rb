class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.1.4.tar.gz"
  sha256 "d3bb488a618fa96e0c1b50db317ae7e9da9cb62d42c2da643731aa94f2fcb724"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9da5c1e57db6f181627f53f6c65bc18e9b8533b7ee43691c9d607237a6c1510c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c638f6c406f19d043f309a18841212b7430c69fdbe30e79e442a4eb0fe233c97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6500563e47b77a95931aac8c28e80ceb7bc47ff0db38a25d1c3a91c52b573a85"
    sha256 cellar: :any_skip_relocation, monterey:       "11e99cdd2ca89e7da78b3c31e08f4b9c0c09c21a8bd2d553040ccd85e98ed88a"
    sha256 cellar: :any_skip_relocation, big_sur:        "37789b704af76fddb2f995729014255b7bbd5729ab22596fd63f373b79dfe744"
    sha256 cellar: :any_skip_relocation, catalina:       "0927144fcebd86ea362e17ce08e64a2253b2a35e647264d784ecda4f433386b7"
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
