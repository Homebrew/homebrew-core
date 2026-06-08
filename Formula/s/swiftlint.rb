class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.63.3",
      revision: "70a5f3225d940d4573d3d2ffcf85b07ab2a6c5de"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9543efe7eb3d5c29413789fda02c3f8d70e4df5e3e4c4f8272dc6497be286aab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f502ca6c67e466021a7f728016682f61645c60e16402c1f8d5ff9020caa24b91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e0b17659999384334ff2e9fe91968853e51f563ef1ad64e5971bda1b5840c3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e454ebe3fcdecdfbda9c2801af0db33e54b71453814edd97fa3a1ba9a07fd7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b94207f2c97ffc84d535fe21cd6fcc64162231e4f8dc153165f82ff817bcb42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc9c5d46560ec79f8c1d6eaaa683ac555184328657eb70a80db4a9409b940dea"
  end

  depends_on xcode: "8.0"

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on macos: :ventura
  end

  def install
    if OS.mac?
      args = ["--disable-sandbox"]
    else
      libxml2_lib = Formula["libxml2"].opt_lib
      args = [
        "--static-swift-stdlib",
        "-Xlinker", "-L#{Formula["curl"].opt_lib}",
        "-Xlinker", "-L#{libxml2_lib}"
      ]
      ENV.prepend_path "LD_LIBRARY_PATH", libxml2_lib
    end
    system "swift", "build", *args, "--configuration", "release", "--product", "swiftlint"
    bin.install ".build/release/swiftlint"
    generate_completions_from_executable(bin/"swiftlint", "--generate-completion-script")
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "Test.swift:1:1: warning: Trailing Newline Violation: " \
                 "Files should have a single trailing newline (trailing_newline)",
      shell_output("SWIFTLINT_SWIFT_VERSION=5 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}/swiftlint lint --no-cache").chomp
    assert_match version.to_s,
      shell_output("#{bin}/swiftlint version").chomp
  end
end
