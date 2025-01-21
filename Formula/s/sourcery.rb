class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/refs/tags/2.2.6.tar.gz"
  sha256 "5e63ed976ca74df7483a6508796ea9d570766e387d3631b474c81b67d1c771f9"
  license "MIT"
  version_scheme 1
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af818510164d00393b484c87bbf617aa785d399da744fd157026e3325553ee18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29573fbcdc7c57968bb93d773ff7e6f26a16c2f9294fde7b2cdaa5379b9dbb22"
    sha256 cellar: :any,                 arm64_ventura: "8e8c8c7e8ec176a95edfb8ce21ee280d9ff5420d03cb90d7caeb60579335a252"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b422f632ebfbaaad72bf6322a8006d330d7cb9af346d782e030becc0f2e0228"
    sha256 cellar: :any,                 ventura:       "8a4809736a2732ad61de0bd27a835081dd66d54fb0438f390c442b7a2902efed"
    sha256                               x86_64_linux:  "48f8ec1325bcae22e80053804d915b42c17368fa2a3c0cb11e755b2b6db8e55d"
  end

  depends_on xcode: "14.3"

  uses_from_macos "ruby" => :build
  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "swift"

  def install
    # Build script is unfortunately not customisable.
    # We want static stdlib on Linux as the stdlib is not ABI stable there.
    inreplace "Rakefile", "--disable-sandbox", "--static-swift-stdlib" if OS.linux?

    system "rake", "build"
    bin.install "cli/bin/sourcery"
    lib.install Dir["cli/lib/*.dylib"]
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
