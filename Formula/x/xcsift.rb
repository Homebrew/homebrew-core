class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://ldomaradzki.github.io/xcsift/"
  url "https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "c7450173f5b078fa745fe791eddae1790178116d318f72f88272206b9130bab6"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8416950d045111001d7e6cd087b979b7afd7780566953d822908614544a2aa0e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a385ac4c5b96354c585297c61ae1883e60a982a96d2e227a8731203748d8132"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d7ca13e39e11259e0c3c1f0278dbe0c07c3b363d9b95ae7cde0349793a5df398"
    sha256 cellar: :any,                 arm64_linux:       "bdee7bedaef8628712949eb201542d18ecee79b913a64910a61f65e7565fa4fd"
    sha256 cellar: :any,                 x86_64_linux:      "134dda27d00ccd354ab8bbcc27dbf59f515be98d0afc24cc8c57dbe0608397a0"
  end

  uses_from_macos "swift" => :build, since: :sonoma

  on_macos do
    depends_on xcode: ["16.0", :build]
  end

  def install
    inreplace "Sources/xcsift/main.swift", "VERSION_PLACEHOLDER", version.to_s

    system "swift", "build", *std_swift_args
    bin.install ".build/release/xcsift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcsift --version")

    output = pipe_output(bin/"xcsift", "Build succeeded")
    assert_match "status", output
    assert_match "summary", output
  end
end
