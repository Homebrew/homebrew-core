class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.53.4.tar.gz"
  sha256 "b0240c8bb006d63ce7263afa7c3c4797a20fbd58f64df8f5109ffb293c5f7b70"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aba78eb02eaa128d7093cede90f2d3180579346953af3c0f34d36fd4e6e6e5ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e688195a59f3f16298c7746c0098f426847a67071e70eab2c6e817813d165f03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5544d90c112912690198cf73c351335acfdd32cc0289ec1e7c87f529c7bbec6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "4bb2b8c5a66ef31980376439b82e5bc8a0dbfb6510c0ac8c013a6906d30f1e16"
    sha256 cellar: :any_skip_relocation, ventura:        "f6791bea686a8cdb500e51c24c322b3c91b3e9c05c638034cf73bb6cf9b9695d"
    sha256 cellar: :any_skip_relocation, monterey:       "5780f282fd2d7bc57f6b937332df13fbabbeeeaa33dcc46e78a92a51740ecfab"
    sha256                               x86_64_linux:   "2ac5008ea51efeac3c633d7f43fb64825294b2448332b7ec33b7ea9955eec9d8"
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
