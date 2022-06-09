class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.1.0.tar.gz"
  sha256 "b6ea521ce3bbd0f55d0f8b61181312bb23a4da6d3605fe449d080abeffe09d91"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77d3e23799835b6c0fdbaf6308d0d746ed1d8c1de79d43525752bc4d8f184b57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eef1a7c97d4cea09678ad51477dab8ebbbd2598a5355b2b53800958a01ca1355"
    sha256 cellar: :any_skip_relocation, monterey:       "33c0ff9b49be719ba29f0ab27dbec54965e6bb5557e550099d0eaf99076e4077"
    sha256 cellar: :any_skip_relocation, big_sur:        "72381811d48ec054c28b932251a8053df476c943558db82d32858442a02fc2da"
    sha256 cellar: :any_skip_relocation, catalina:       "cd2d8252bcfdd81124f9eaa748ec4d01accc96aea345937de02ea351daf555cc"
  end

  depends_on xcode: ["11.2", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Weaver uses Sourcekitten and thus, has the same sandbox issues.
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/weaver", "version"
  end
end
