class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/refs/tags/2.2.4.tar.gz"
  sha256 "66f687ad7643ec92bc69cb106779841023783bbb336be2ae35621dbd667a954f"
  license "MIT"
  version_scheme 1
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "898113633aa39a5ede9418a94bf7d83ad787eb9d47645189b74c113fe484953f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dfcede759de9043bc9cfdaf6856b21e72903d8f384fcf10c29aaf7d837edac4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b204388b272925fedc3f41e06ddc6d95ab2732ebafb69888113cc460f619f47"
    sha256 cellar: :any_skip_relocation, ventura:       "f6f01c83e4a313db2d3bb5c41c7be26e808231110ec377fe782a444c44049cae"
    sha256                               x86_64_linux:  "6cccce3ac817cf3342e4eb719e2f84fb1b0ff243469f722fddbc6079969fce64"
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
