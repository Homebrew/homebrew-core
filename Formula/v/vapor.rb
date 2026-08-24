class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/refs/tags/20.0.2.tar.gz"
  sha256 "7891c84f8d58fb4724054c69feb803181c27238579f4554ce8e300228004df14"
  license "MIT"
  head "https://github.com/vapor/toolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74cfa46115a5eed7f286976223201bf8591812c99a40a99f4ac5a92aa9556dab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4ce207c66f4c6041934098bdd900d82c0d74290dbf52d0f6cc18c8d9899e780"
    sha256 cellar: :any,                 arm64_linux:   "1649275728cd8456e616cb802216706b72a0b2f5c803efdbbea190c70ecee0e8"
    sha256 cellar: :any,                 x86_64_linux:  "57eb082ec54f0d0a837e422f332ed464877df153bc795443bbe9cd12cfd0d380"
  end

  depends_on xcode: ["26.0", :build]

  uses_from_macos "swift" => :build

  on_macos do
    depends_on macos: :sequoia
  end

  def install
    system "swift", "build", "-Xswiftc", "-cross-module-optimization", *std_swift_args
    bin.install ".build/release/vapor"
  end

  test do
    system bin/"vapor", "new", "hello-world", "-n"
    assert_path_exists testpath/"hello-world/Package.swift"
  end
end
