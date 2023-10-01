class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.52.4",
      revision: "9eaecbedce469a51bd8487effbd4ab46ec8384ae"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e5803cfd7481bf6b5c0de58364add25be04b1f723936e72aa87e195f6469b6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "718f5989e0909ea736848e0d6f32d07cfa20bb23cab5fb9989803872e88d1a29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcc2c13aa6c01634b382991df048bb331caa5eec230fff33ddbab19258a30c22"
    sha256 cellar: :any_skip_relocation, sonoma:         "69bb850978f4b454fa1930d1cda7fb39381a08af540320ac6eec5dfc834ea04f"
    sha256 cellar: :any_skip_relocation, ventura:        "5aec3b872abfead26c702334f0cffddb8ea653481720d7c1248ad836be37a975"
    sha256 cellar: :any_skip_relocation, monterey:       "e3171413a8649150601f777176af1dae458cb4be35aa1185e31636db1bb7124a"
    sha256                               x86_64_linux:   "e8ec45e149d2e33295ddcd87a142389492176b51d0c2216127ae00d3ade33a6b"
  end

  depends_on xcode: ["14.0", :build]
  depends_on xcode: "8.0"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release", "--product", "swiftlint"
    bin.install ".build/release/swiftlint"
    generate_completions_from_executable(bin/"swiftlint", "--generate-completion-script")
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "Test.swift:1:1: warning: Trailing Newline Violation: " \
                 "Files should have a single trailing newline (trailing_newline)",
      shell_output("SWIFTLINT_SWIFT_VERSION=3 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}/swiftlint lint --no-cache").chomp
    assert_match version.to_s,
      shell_output("#{bin}/swiftlint version").chomp
  end
end
