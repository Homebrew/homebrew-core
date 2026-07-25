class XcodeOffload < Formula
  desc "APFS-backed external storage for Xcode and CoreSimulator"
  homepage "https://rudironsoni.github.io/xcode-offload/"
  url "https://github.com/rudironsoni/xcode-offload/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "9d9e5af55ee5ba6bb6ac8392b32e80fe35188abc51b18326efa752434c847b9f"
  license "MIT"
  head "https://github.com/rudironsoni/xcode-offload.git", branch: "main"

  depends_on xcode: ["16.3", :build]
  depends_on macos: :ventura

  uses_from_macos "swift"

  def install
    ENV["XCODE_OFFLOAD_RELEASE_TAG"] = "v#{version}"
    system "make", "generate-version-source"
    system "swift", "build", "--disable-sandbox", "--configuration", "release", "--product", "xcode-offload"
    bin.install ".build/release/xcode-offload"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcode-offload version")
    assert_match "manages external Xcode", shell_output("#{bin}/xcode-offload help")
  end
end
