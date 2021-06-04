class SwiftSh < Formula
  desc "Scripting with easy zero-conf dependency imports"
  homepage "https://github.com/mxcl/swift-sh"
  url "https://github.com/mxcl/swift-sh/archive/2.3.0.tar.gz"
  sha256 "512ab6ba0899258673e040fa434a2ee4332128eb6ae47f63b146477667ea2d83"
  license "Unlicense"
  head "https://github.com/mxcl/swift-sh.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d90522741b5bfdac8d8d79375cce90984af0967bca1e84e8f5f9758b29e36616"
    sha256 cellar: :any_skip_relocation, big_sur:       "490aaac152cd73af4711850ef3bf137d3db6ae8217f384dff4a9551dfafc5783"
    sha256 cellar: :any_skip_relocation, catalina:      "d3993862ace65ec747846eadfad6110157e2de946e0b416355e6bbe321d7ca6a"
    sha256 cellar: :any_skip_relocation, mojave:        "c7ece92d3a20f75c5a7551fb1a46b0750912e29021bae73a9e5e7f8d8e2397b3"
  end

  depends_on xcode: ["11.0", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/swift-sh"
    bin.install ".build/release/swift-sh-edit"
  end

  test do
    (testpath/"test.swift").write "#!/usr/bin/env swift sh"
    system "#{bin}/swift-sh", "eject", "test.swift"
    assert_predicate testpath/"Test"/"Package.swift", :exist?
  end
end
