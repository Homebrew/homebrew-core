class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.53.2.tar.gz"
  sha256 "3961925646619cc7c10b3949d720d5154e57fab8490c517fc691ed45b4e93af0"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e23df7cc20f91e8a54c665b5da4952f13d53cfa658751ed9d6efbbec39f425fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf9654736aac1bcd6201d42277f5feaa261bf82e54dc75277cccc6f001b04657"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9e78f333f16c6ef8eaf00c9f56685d90c455552e49691473a6e8184256bfd38"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6aba634d12b4e23da0c4cb5f8d7d1b36036fd966f243764b5c624a4bf57a794"
    sha256 cellar: :any_skip_relocation, ventura:        "ac23688353c12e6e50a4f6ad388232ae7ef23c849ad7280c97ede5c6a2ec3b0b"
    sha256 cellar: :any_skip_relocation, monterey:       "ba227da0de2d6451e1407acc3b447f035578deb7c8f8bcd78645309cc9423e79"
    sha256                               x86_64_linux:   "f1c2591afe87f93ff9db7b9bf755200b41e9eb14ae0641cd6290cb85e597c467"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
