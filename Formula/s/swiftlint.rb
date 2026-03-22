class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.63.2",
      revision: "88952528a590ed366c6f76f6bfb980b5ebdcefc1"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ad276ba7ae7348568afe4a5bb626a9f051e0aac2f1c601764e2bf23d3947c49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47176ffa07d052fe7510bce247d4e57ba030bdf9adf26ba6822cb2f43d8efefa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d66bb4281b662bd332c65575527415e37e99bd78b2c64063825d11df46591077"
    sha256 cellar: :any_skip_relocation, sonoma:        "6950d654181f4ba4c82ffb760c95b2e19cfed713ba924baef08f9a2a3ce3c9de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ef09967cda2dc493af8039f8b13731a22a4e09d6bfa761de608b5944eb01a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8408453159a1aae0ea8abfc5bf3c8c3b3275891099130e13f96bfbd53a0bedb"
  end

  depends_on macos: :ventura
  depends_on xcode: "8.0"

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "curl"
  uses_from_macos "libxml2"

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
