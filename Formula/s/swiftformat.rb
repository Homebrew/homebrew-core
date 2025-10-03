class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.58.2.tar.gz"
  sha256 "d1cb20a84ae57ed43bd5f955ea635e72a51d2e51de89e3a7201d9253123c899e"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fd59fa0a57591c9acf75a387ca8884ef21db0ecff35181f2cc794af36add6bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef9fe370d108a3d6a035dce23cbcbfaf92e04d9c2f108d6f24a8994e06155c8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "789571cc4a71d59a56d3b88c063d61473b03cd6c240245861c50c2c35674579b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea3856ad5080e3890d2d7511cbff8676280929e611693162973017f5237eb479"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6231f27b3ed3c69059f1be79be2de9b2f7eb93b36cdc33a734acfa2948cd003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5e57614977135123857684091f996c755e9190f16eae07faf82df58baf3cad8"
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
