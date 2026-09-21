class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/refs/tags/20.0.2.tar.gz"
  sha256 "7891c84f8d58fb4724054c69feb803181c27238579f4554ce8e300228004df14"
  license "MIT"
  head "https://github.com/vapor/toolbox.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "648947c1a7ee2636b801057f502e529edac0aa87cf1f37c96508abcaa0f43fe4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d7141680a4ae37fc708f0c89a13e3e3f80d24133f951514042ce9b2e724960d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "46f4b86f2f0e4ac77a3c4f83951fb044a4ce019372fe0a74f45b961f13df05c6"
    sha256 cellar: :any,                 arm64_linux:       "4259332f366f8de7c4852127f4f13f443db6ca6a1ac11d74ea77010d22990db0"
    sha256 cellar: :any,                 x86_64_linux:      "a0780e507e178ee981f0d5afaa9d83ae752890e3a7832f7f4e1ae2f7a34fd9f4"
  end

  depends_on xcode: ["26.0", :build]

  uses_from_macos "swift" => :build

  on_macos do
    depends_on macos: :sequoia
  end

  # Test clones the project template from GitHub
  allow_network_access! :test

  def fetch
    # SwiftPM tries to apply its own sandbox, which cannot nest inside the
    # build sandbox; Homebrew's sandbox still confines the whole process.
    system "swift", "package", "resolve", "--disable-sandbox"
  end

  def install
    system "swift", "build", *std_swift_args
    bin.install ".build/release/vapor"
  end

  test do
    system bin/"vapor", "new", "hello-world", "-n"
    assert_path_exists testpath/"hello-world/Package.swift"
  end
end
