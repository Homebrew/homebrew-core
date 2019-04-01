class SwiftAbstractClass < Formula
  desc "Compile-time abstract class validation for Swift"
  homepage "https://github.com/uber/swift-abstract-class"
  url "https://github.com/uber/swift-abstract-class.git",
      :tag      => "v0.1.0",
      :revision => "66a1e878cb2d669b3139176902b7d997a92cc7cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "85eeb9823bb921011090ac9f3d03859da4e8799815601191dc8096782ac4cd1e" => :mojave
    sha256 "7a94d05e63913eaa6527dbd5fbad96e1d572b6fed270d7d2136440206e2829a2" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :xcode => "6.0"

  def install
    system "make", "install", "BINARY_FOLDER_PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/abstractclassvalidator version")
  end
end
