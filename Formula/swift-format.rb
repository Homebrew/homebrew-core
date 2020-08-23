class SwiftFormat < Formula
  desc "Formatting technology for Swift source code"
  homepage "https://github.com/apple/swift-format"
  url "https://github.com/apple/swift-format.git",
    tag:      "0.50200.1",
    revision: "f22aade8a6ee061b4a7041601ededd8ad7bc2122"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/apple/swift-format.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8f72c33efc125e2904e1bec2c8942cca75d75cf81dcab7fcf08ba124af16170" => :catalina
  end

  depends_on xcode: ["11.4", :build]

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
