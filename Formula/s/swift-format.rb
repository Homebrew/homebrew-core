class SwiftFormat < Formula
  desc "Formatting technology for Swift source code"
  homepage "https://github.com/swiftlang/swift-format"
  url "https://github.com/swiftlang/swift-format.git",
      tag:      "601.0.0",
      revision: "ffbb3225ffda37b62c7283c70e87e8bc7e8e202a"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/swiftlang/swift-format.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd4509cdd27b42bab34ffa4dd8af88c5f851e4996c71f511aa69e21595308f51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c67cc2e1b479b85ea8cd42c79c3251fe0f06bfeefc8fda2e1df72ed745dc243"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cad872e59a50e0461915c4412c23949ab4104e566ef387149dd246b377816881"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e46febcf28e10a46cb5dce2ebcbec18230f661221493d1bdfb9dc74e4e91987"
    sha256 cellar: :any_skip_relocation, ventura:       "9a080668eb1f1d87354c99cdfb31a65c76b3f51a797484a81ccee7a9a1386ff5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09f0c3b6f509becd131c30ea8446a9fdb4332d08a1ecd6b370dd6e2b492decec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6370e3eca7bfcc407ebdc14481cb809206c71abc40caeab02d11533f1c228254"
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
  end

  test do
    (testpath/"test.swift").write " print(  \"Hello, World\"  ) ;"
    assert_equal "print(\"Hello, World\")\n", shell_output("#{bin}/swift-format test.swift")
  end
end
