class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/0.11.1.tar.gz"
  sha256 "1d39ffbc1003905120e5be3cbb362d7fdbd963e944f8d44ca21ea4c2756631bd"

  bottle do
    cellar :any_skip_relocation
    sha256 "40e8c3d2532e3d3da0cc9ac57002ab7dc3f6b6055e7c3ee059f8a0500da6e54e" => :mojave
    sha256 "5ae9daca26eb19ba8277dcf7ff34992685c93a9453b1fa94ae02abfdd6cb47ca" => :high_sierra
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
