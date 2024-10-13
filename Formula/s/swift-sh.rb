class SwiftSh < Formula
  desc "Scripting with easy zero-conf dependency imports"
  homepage "https://github.com/mxcl/swift-sh"
  url "https://github.com/mxcl/swift-sh/archive/refs/tags/2.5.0.tar.gz"
  sha256 "07f3c2d1215b82eb56ebfeb676b5e3860c23a828c14fd482c7c1935817f3220f"
  license "Unlicense"
  head "https://github.com/mxcl/swift-sh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12aa7fb55fb0e16853c74f8cd5df5821e7776c094014886b1a90c02d420b9285"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7500eb089b869ffa76b33da5bda4ce0302de35a4ac8a59e6c18adb0625f411fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c7aa965e55200dd565dbd5e2cc043d0bdd8c9d4233d38a9db6b8df30e0eaeb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad27a459cf97037ba309bc4355eda4f0f6131e8cb1555a7e5c5e9ee843a430a0"
    sha256 cellar: :any_skip_relocation, ventura:       "289932a3550e9c62c92a92a41a46bd5cfda97e565f4309508b8e12a8152e63f8"
    sha256                               x86_64_linux:  "7901f52534d4f539a8dab87a864007058f9b2d9cf048b418e6d74870f7027d3a"
  end

  depends_on xcode: ["11.0", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/swift-sh"
    bin.install ".build/release/swift-sh-edit" if OS.mac?
  end

  test do
    (testpath/"test.swift").write "#!/usr/bin/env swift sh"
    system bin/"swift-sh", "eject", "test.swift"
    assert_predicate testpath/"Test"/"Package.swift", :exist?
  end
end
