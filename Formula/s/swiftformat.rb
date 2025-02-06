class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.55.5.tar.gz"
  sha256 "e54bc4af39e33f16db5baa0164e265ea70635d8ff68f1844eedc857d69e6e1a7"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03b760299367f33b053cd52569571d994958db21dedf1f8193c7ccbc9e547f37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90f8a2be039536ad7f9efe582625621ad401c9974fd576567848d25b6ff17de1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "537b6e3d52c5f56766b51086ca7701536e30f05a3ee047c48b54dfc39ea63fe0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e78a4f8ee446b67de146e0f3fc8fbf37bd688c21bf5c1fd3b35b5c30c36928f3"
    sha256 cellar: :any_skip_relocation, ventura:       "390624c68b005a3afa47801f7b672fc52ed7634f7357ec4d2e9a80872ae9afad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a93847570378567d7cb33d978a65a7d5cb4e3a7c25c667fdb6c71541a7c13f87"
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
