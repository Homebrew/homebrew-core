class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/0.12.3.tar.gz"
  sha256 "638a08e996ac1fc5b8d945870a4f8af7548a9c59f8b2164c4f766f049a512033"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee9b039b758ae1a7cdd182887b450c985ca37fb839ef9c486bda859af0df5f6c" => :catalina
    sha256 "8158b3c36bb668c361660b7d433779faf10f3eb8038528b5f26cda4f4966e238" => :mojave
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
