class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/0.12.0.tar.gz"
  sha256 "ff1d33af53c10157e35c3dc0f63cbcd8a4e2c19c71580fe952636a36b0364ffb"

  bottle do
    cellar :any_skip_relocation
    sha256 "544e84d0a6cb021c58fb3f39336a148dbf706e9684c1e93ee66954917b3a3ef7" => :mojave
    sha256 "ad0a9de9957a44be85277aadf02d8d93de1120089551bbf7d8454666e1a19d90" => :high_sierra
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
