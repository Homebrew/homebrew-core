class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/0.12.3.tar.gz"
  sha256 "638a08e996ac1fc5b8d945870a4f8af7548a9c59f8b2164c4f766f049a512033"

  bottle do
    cellar :any_skip_relocation
    sha256 "27672bcc5f5609d0826a637fd3be2d8a2022199cd3682dc49969cc8544d71f65" => :mojave
    sha256 "b1629b78af3f48d23d914a3ebaba27cd04824bb2db2ff5f97732ef5136611141" => :high_sierra
  end

  depends_on :xcode => ["10.2", :build]

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
