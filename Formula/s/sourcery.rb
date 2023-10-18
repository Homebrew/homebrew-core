class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/2.1.1.tar.gz"
  sha256 "6a5053b3cdc220c02e52915c1f285bf835049ebb3038b39118dc5df4110cc0ef"
  license "MIT"
  version_scheme 1
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c9a00e99520c5fd1632b117f2e67069675ccd13e3ee9455941f2848687de5de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b830387533d8a4356e35ddb896b8be2bd80da75dcddf5ccb213a1f3604dd44d"
    sha256 cellar: :any_skip_relocation, sonoma:        "32b7f79c6258a96e1d46a977b27d41fb7d9683b487e6b8c68739b6a0912dfa26"
    sha256 cellar: :any_skip_relocation, ventura:       "fd06b30db30585ce954a51b22c13c7512e3024f859f159dd313156d2a5ea6c36"
    sha256                               x86_64_linux:  "f2903a70b16fb835bcd91c90b28b8dbae75418f9881959266d2459aa8212a966"
  end

  depends_on xcode: "14.3"

  uses_from_macos "ruby" => :build
  uses_from_macos "sqlite"
  uses_from_macos "swift"

  def install
    system "rake", "build"
    bin.install "cli/bin/sourcery"
    lib.install Dir["cli/lib/*.dylib"]
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
