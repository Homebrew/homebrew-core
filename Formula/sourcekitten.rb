class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag => "0.21.1",
      :revision => "e6efd3d8702fe6668ac43aa882d56f82430c6caf"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0a29b526cf23343379204e6b01b1f73ff5d18c9b61e300e38d9539e26d562d8" => :high_sierra
    sha256 "8509bd4310104cf83a18d22d207601565cbb398f73d2e0d261550feb3ac66899" => :sierra
  end

  depends_on :xcode => "6.0"
  depends_on :xcode => ["9.0", :build]

  def install
    ENV["CC"] = Utils.popen_read("xcrun -find clang").chomp # rdar://40724445

    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/sourcekitten", "version"
  end
end
