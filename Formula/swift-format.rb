class SwiftFormat < Formula
  desc "Formatting technology for Swift source code"
  homepage "https://github.com/apple/swift-format"
  url "https://github.com/apple/swift-format.git", :revision => "fc5a3da1d5d03143d7a31b12514349e2bf1aba8f"
  version "5.1"
  head "https://github.com/apple/swift-format.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "78116d711e3e5b5fc5bc08ee95db22583636a9bb17932a59236e02b1ffa3f3da" => :catalina
    sha256 "bab43b73e8322b8acf5478f282bc6b8f019632569dfb0f487715c2633ba869c8" => :mojave
  end

  depends_on :xcode => ["11.0", :build]

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
