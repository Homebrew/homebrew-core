class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.58.3.tar.gz"
  sha256 "aa126b578652bce9b54bd9d8580a0f1da5723e574da2f8ba292968af13978312"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b57454021af9a15bd0e86ffb9b0992dbfd9b297fa9f203f3fd492e8c01ff854a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70f6e87f9ba1f8b0986d6ab48e5cc4c1955fd62be887c853720c9edd68477e28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0889ccb73cd13f58a05f29e597d5c20d313a73339e897d46b80bf431475453ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "deac306e9b0e989a271d85debc8a7532527a353a4c5fc2e04ffb9e1063a306c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7aa60a72d89a59eff228681265a7ca7f69e5895c8d13f87efc52ef0d577fa753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "323e94a568c3d202909a2afd7cd033442b22cd33ae50b50e7a7885a16763c9db"
  end

  depends_on xcode: ["10.1", :build]

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
    system bin/"swiftformat", "#{testpath}/potato.swift"
  end
end
