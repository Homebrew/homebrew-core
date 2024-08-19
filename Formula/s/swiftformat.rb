class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.54.3.tar.gz"
  sha256 "f0fb5df2945d49207ef50da971810e6879acb0153267bec0be0d882f77781649"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cecdcf7705cb91f9ba9d08793c67edd61b7e1d1acbe2ee1ef598acfd7cfcc6b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2222e0ffee8931b40c61548237ff2037a0e99139089a6df6ab4f3e1a23d0b7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e87d9ce5bb0f266c6a31e13752aa74b0ecc895b87eaec987297e2c24b69c505d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e56f11df75c29a52fc1a14d99fb0808858e15f989aac824202ca8380a29a5073"
    sha256 cellar: :any_skip_relocation, ventura:        "1c4644e0db67009e71d72ff3139a870898f47dbdb38e4b1f9ca19e16e507a025"
    sha256 cellar: :any_skip_relocation, monterey:       "b564501ae28caf4b5108a1ba351a6eb6f989522353cac25e078e8edf88239c96"
    sha256                               x86_64_linux:   "82a084203a146c3f27e80440c3c5fc7c1222e1c58e8743445d3e880d1d913957"
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
    system bin/"swiftformat", "#{testpath}/potato.swift"
  end
end
