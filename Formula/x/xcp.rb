class Xcp < Formula
  desc "Fast & lightweight command-line tool for managing Xcode projects, built in Swift"
  homepage "https://github.com/wojciech-kulik/XcodeProjectCLI"
  url "https://github.com/wojciech-kulik/XcodeProjectCLI/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "47e282024767603d31eed14ccc7082585409df58b7a8eca9009be3f4fce2b814"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f722a7a9bdaa2636b67d70317ae8e2894b0a756a259316b1eeaae2689304dca7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8ee39e8b353b40ba2151af5b8f932adf7dc639d25eaad39ffc74ac2f30b244ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e35121b99ba7d4c6c28fb4c223ba8a8d5d79a962ff133b867f35f1dae0fb597e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "63b7315b3c98df2101c4ae36d70a9b5aaf97458d3e766b6c9282732032a7179a"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    system "swift", "build", *std_swift_args
    bin.install ".build/release/xcp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcp --version")
    assert_match "Error: The project doesn't contain a .pbxproj file at path: #{testpath}",
                 shell_output("#{bin}/xcp list-targets 2>&1", 1)
  end
end
