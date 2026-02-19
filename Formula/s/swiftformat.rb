class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.59.1.tar.gz"
  sha256 "815a085ad68bab6a586a3daf6ca418f1bd4f2e0ba35c144aab46399902eedc53"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c76356c57d619449810b92c9984bfcfd0d389bbbfe199f3e77dbb44f0fc88be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6734b47f083244416e49b4eab8086e549af1fc3fcd7ad1294b48182f7025250"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6029d5206b977ad3395f04d07e4e2daf450eda94d8d8f60c1a700282cd1678c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb7311da1bd96c417f1616bf2bc896fbaa97632b85e93204dc170017dfec5d60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a4629857f29c90adfdf46552a8505b233baa6b1aa8558c6485cf3f45583ad34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "488978676c97f371b9f15764fc50e8f12c9520e33e086049ecc95e93351b0a22"
  end

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~SWIFT
      struct Potato {
        let baked: Bool
      }
    SWIFT
    system bin/"swiftformat", testpath/"potato.swift"
  end
end
