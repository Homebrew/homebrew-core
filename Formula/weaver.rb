class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/0.11.0.tar.gz"
  sha256 "ffd230e912071ca1d6f6f2fd4a11c74d0db61f5263cdabdbd54f6e5412f216c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e0de15700f598a412e31e505e620d57db673900a6ceb4227df1e69ccb7286c3" => :mojave
    sha256 "bd2fc8164642b46f72df35e06a0d0f9fbd64179f4ba6b59d9cf380fd0d2252de" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Weaver uses Sourcekitten and thus, has the same sandbox issues.
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/weaver", "--version"
  end
end
