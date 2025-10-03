class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.61.0",
      revision: "cc6fbaf355caf9ebe02c1b631a8edaa6df9145c5"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f33b770513e12ed36ebb72e3812c8f45817c6fce39ef9bdedeb10a752d66fdc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cac8a981bfeaa142813a7a3adc6334ed26efdaed6e6affc985a9ff47528487e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34d8e5a9d66fefa9b415f1262586689be516b0ea54d8da45848555bf591dd72c"
    sha256 cellar: :any,                 arm64_ventura: "d1abea2e22df0547b7ec21cfc90f8e8944421decfab6da7629e9a04a0fc8bd47"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d476c377c7bda7b059ab3ebd5333d6010d62dc8c6a798ad2dcfefa4a03de13c"
    sha256 cellar: :any,                 ventura:       "18b7fdea8c79e9d301a19283f74351df655bc7f06945973cfe29cd78b4e33acc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f248613371743e23145518694bde0d1183a5699a061157121fc68c200aeaa0ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77136311e7954b0c8c50642de7f74a62050450dfb6ab46285105a13306ff816b"
  end

  depends_on macos: :ventura
  depends_on xcode: "8.0"

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
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
