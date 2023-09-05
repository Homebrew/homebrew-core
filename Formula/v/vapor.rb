class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/18.7.1.tar.gz"
  sha256 "f0d3f0676de0e9c492a0a7f1d4a3c42bb2c103a4c86d0d78c548556090cd4f0f"
  license "MIT"
  head "https://github.com/vapor/toolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b4915ff63abcee4712993b6e0a249aefd568f20e4c3ed984fd03cdc8d2cb4cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f67958d8b7764eb2359bd301392cf3d1f7b0c355ab56f89c47cd93270a146e81"
    sha256 cellar: :any_skip_relocation, ventura:        "f66cb3190b831f10c73cae86140d096c81801f0cd8b2858655fed2abff369f36"
    sha256 cellar: :any_skip_relocation, monterey:       "12dcd526a2ec89b98f2cd94ddf3bbcb5fc71adc7f527a8b8cdf636751cf77ffb"
    sha256                               x86_64_linux:   "32a84eac9df8cd04e575261cc49e23ca14ed198e4fcfec86da8960dfec7170a9"
  end

  # vapor requires Swift 5.6.0
  depends_on xcode: "13.3"

  uses_from_macos "swift", since: :big_sur

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
      "-cross-module-optimization", "--enable-test-discovery"
    mv ".build/release/vapor", "vapor"
    bin.install "vapor"
  end

  test do
    system bin/"vapor", "new", "hello-world", "-n"
    assert_predicate testpath/"hello-world/Package.swift", :exist?
  end
end
