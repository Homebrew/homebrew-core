class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag => "0.21.1",
      :revision => "e6efd3d8702fe6668ac43aa882d56f82430c6caf"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b7a94307e488a6c6c078b80eaef6623036460b8f25f5c411a713f1f2ba1ce8a" => :high_sierra
    sha256 "06e656a7a6f473ba036881250cd84a8cbbf3a9362d5708706d1289efd1b6623b" => :sierra
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
