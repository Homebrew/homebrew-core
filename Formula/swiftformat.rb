class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.51.11.tar.gz"
  sha256 "90a23bf626ab216a3c064011d3defa39c8085b7e3752d5e5ba38fbf3bacf00ac"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e1d233ee4d364f4c8b8687699f007496bcf36e49cd8356cf1d675e7daf518f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2710266d2afdfba2af509df2e74464798eca5c5ee4c3ba83f1915b5fd5047b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88c2535f93a1ea08cf83e5abeefcbf60184288b7ff2e2305ac1fb55293c2244a"
    sha256 cellar: :any_skip_relocation, ventura:        "b727766ca3e916d10dbf43f04d669614ce57ea599f68567fcf66f9bb34c0c65e"
    sha256 cellar: :any_skip_relocation, monterey:       "122ad4010de20fe9c1b147c47b66dd9fb671f8ab3ea91d570bf813c2821e24a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "94a7182fb6134f6a4046c8c01fe9b174b174cce4b149f72d92eb39f26ecdd776"
    sha256                               x86_64_linux:   "77081cf0f8af8c7f43e7b57d3af0d1b2b4af35922a5091386a416229589da749"
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
