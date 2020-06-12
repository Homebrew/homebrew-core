class SwiftFormat < Formula
  desc "Formatting technology for Swift source code"
  homepage "https://github.com/apple/swift-format"
  url "https://github.com/apple/swift-format.git",
    :tag      => "0.50200.1",
    :revision => "f22aade8a6ee061b4a7041601ededd8ad7bc2122"
  version_scheme 1
  head "https://github.com/apple/swift-format.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e83034b8389fcc1a6a72874771246e79a0d49990fde28a14c906f9cdcb2a4be" => :catalina
    sha256 "cbb6b0aca421587fad3aad6ce5341ff98513ef0899cdd6aa8c9b6713d670315e" => :mojave
  end

  depends_on :xcode => ["11.4", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/swift-format"
    doc.install "Documentation/Configuration.md"
  end

  test do
    (testpath/"test.swift").write " print(  \"Hello, World\"  ) ;"
    assert_equal "print(\"Hello, World\")\n", shell_output("#{bin}/swift-format test.swift")
  end
end
