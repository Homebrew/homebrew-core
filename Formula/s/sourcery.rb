class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/refs/tags/2.1.8.tar.gz"
  sha256 "a26c0993abde9af96aa5eddfdaa843454f9290a89c193c78867f7481695c8746"
  license "MIT"
  version_scheme 1
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "162028870eecabd1fcd8a92ba7a6a072fe35284c288fbd118f261861ac99b132"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71eca4a853087036a4ddfd507252c71080f1fa0f69b5ec6e329b741b71376dfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b8075a3c20c8f0c211aeb53dcbb249f3cdc461534c7e2d56bd78164d1775cea"
    sha256 cellar: :any_skip_relocation, ventura:       "b63bc6879759ad913c2ac627bb897d99c103684b43ee783a7575958526429a8c"
    sha256                               x86_64_linux:  "32f03ba0862ea915dffcb547f1902d9142894fd14538165cc27eb66d1f0cbd17"
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
