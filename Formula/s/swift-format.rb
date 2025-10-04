class SwiftFormat < Formula
  desc "Formatting technology for Swift source code"
  homepage "https://github.com/swiftlang/swift-format"
  url "https://github.com/swiftlang/swift-format.git",
      tag:      "602.0.0",
      revision: "62eaad2822b865407b8cde56c36386c00800f7ec"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/swiftlang/swift-format.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df0fdcc1a40fd5424122f4db14f70df46b02de3b9046943e4155b560e79ae0df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d285bdbf31bfef50a23b070acc56af33e3f3a5534e8ef1f4a6cd6700a107359b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc2710feb43f03ca1417032da7decc1a4b5720f9cc41d74bbf075abf83c11576"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc7b5fa4b9a56bd360dcf766b2951851f8b62baafff325827a037e394ca9dd24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba98b0fe314e54fc94bb2b1fa298c1fcb7bc5cbd01128643ba343ddf808cd5e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bd08266274e09c11c73d0f7d8c1b730ae6b6e86d9c25b1b839ea048cf71fb1b"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on xcode: ["14.0", :build]

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release", "--product", "swift-format"
    bin.install ".build/release/swift-format"
    doc.install "Documentation/Configuration.md"
    generate_completions_from_executable(bin/"swift-format", "--generate-completion-script")
  end

  test do
    (testpath/"test.swift").write " print(  \"Hello, World\"  ) ;"
    assert_equal "print(\"Hello, World\")\n", shell_output("#{bin}/swift-format test.swift")
  end
end
