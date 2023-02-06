class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/2.0.1.tar.gz"
  sha256 "bc28b9b0392b91e7787ca7e4c02e16aed11b39e940e8916e2c0cf745b1163fb1"
  license "MIT"
  version_scheme 1
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "723cc4e0a495920267bb5b241774d350eb313d44458347bb09c803b0e3f85186"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5072dcb0529c0455aeae19619e7be7a5fd6106649217ea59957e9eed2542465a"
    sha256 cellar: :any_skip_relocation, ventura:        "4132316be272e76fd079a070f809798b394eb08b4d021a1e47828692ad6c64a0"
    sha256 cellar: :any_skip_relocation, monterey:       "f7aab882c75f95141ef8cff04d6c363e568901ebe686a8b4ffab0d2b83d1a2e6"
  end

  depends_on :macos # Linux support is still a WIP: https://github.com/krzysztofzablocki/Sourcery/issues/306
  depends_on xcode: "13.3"

  uses_from_macos "ruby" => :build

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
