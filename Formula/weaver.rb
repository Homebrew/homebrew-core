class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.0.0.tar.gz"
  sha256 "976bc968b51e45f8840e527ca56624e7db4a9f9e620dc586e1ab01c41dd90209"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee9b039b758ae1a7cdd182887b450c985ca37fb839ef9c486bda859af0df5f6c" => :catalina
    sha256 "8158b3c36bb668c361660b7d433779faf10f3eb8038528b5f26cda4f4966e238" => :mojave
  end

  depends_on :xcode => ["11.2", :build]

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
