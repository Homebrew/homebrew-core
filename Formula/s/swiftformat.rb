class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.53.5.tar.gz"
  sha256 "e5aeb42b934fc422e8992954d5ec6f34bf699c16493c57f28420e990fac42530"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04e089d4b1ae1217dd6c8133b3c661add56d7c4f4f24ee67becd3cf8f54e6e80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19a6ce102e7df1cdee150dee619025aa3b2a4980070bee4f8cdd6976c0936d46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "745ba037da0e1fe62f2f22faa45a17655b89d8870bacd9db32597ce1fd779509"
    sha256 cellar: :any_skip_relocation, sonoma:         "6830f0bd5d06dca19d2bcd614e6d0c87e7a3d703d33bce90d0448a83310dddcc"
    sha256 cellar: :any_skip_relocation, ventura:        "dacbfeca6cbe99fc73448f08c0289f135e807bc220ac1dcb61952410f1b43535"
    sha256 cellar: :any_skip_relocation, monterey:       "a5e30f5378aca201ca8bc7a350ebac28b3202366be1b37cf254f77c27761753a"
    sha256                               x86_64_linux:   "909ae79dbe735c9377355e202d07a58aeff1af1707ba7a3c843cf7c3b10f68a9"
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
