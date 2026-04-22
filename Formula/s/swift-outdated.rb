class SwiftOutdated < Formula
  desc "Check for outdated Swift package manager dependencies"
  homepage "https://github.com/kiliankoe/swift-outdated"
  url "https://github.com/kiliankoe/swift-outdated/archive/refs/tags/0.12.0.tar.gz"
  sha256 "8072d0a0ff3e35ef5a52038e22ad4bbac2f4083bb17c129b4444587d15887991"
  license "MIT"
  head "https://github.com/kiliankoe/swift-outdated.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84fc1f86f8290fdfe745b205da0d8b09d1acc4741c2166f97753e51266a04962"
    sha256 cellar: :any,                 arm64_sequoia: "2785fc6288f5f2b8ec1044bedcf9da53510b0e5967791636d770b04089afc49f"
    sha256 cellar: :any,                 arm64_sonoma:  "24b974eab015b91fe5d0571ca2353bc6dab0beb85f45de5f453cf3fcdfc0e243"
    sha256 cellar: :any,                 sonoma:        "80fe02657dac5547c4b3c6222af177ecf2869009827fc67ea6b366e1f0dab6c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4491af55dd0e7e5d9dee0af33fad8f46f3980cc94b65884ea5a6a6b9ff0f0187"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77a743bdecfbf38ad45354d50beb6cda87c013078a33224160b7375f2c37b44a"
  end

  uses_from_macos "swift" => :build, since: :tahoe # swift 6.2+

  def install
    inreplace "Sources/SwiftOutdated/SwiftOutdated.swift", "dev", version.to_s

    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release"
    bin.install ".build/release/swift-outdated"
    generate_completions_from_executable(bin/"swift-outdated", "--generate-completion-script")
  end

  test do
    assert_match "No Package.resolved found", shell_output("#{bin}/swift-outdated 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/swift-outdated --version")
  end
end
