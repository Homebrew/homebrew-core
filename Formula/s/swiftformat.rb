class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.55.0.tar.gz"
  sha256 "cd6d979c8bb42cd0b2cb6596d5d2134d104e2a6d91fff6d55708c2d5b1341eb3"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "809f0c585e3138190f5cf42ffa923c3c06a03f1d78f7c453942628de5fdd2f10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd7c73d0d7703640e3b3346bf28952b9ecd01fc67f77951c45e53b30661fe2e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b81b1919b476929f6508785af9a3126d64be97cf3ad87f3c66460d3157b1bed7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a433ce5b06ea8aef6d65a2c67fe3d2a78a34bb10db28dc63d5cdba94e844173c"
    sha256 cellar: :any_skip_relocation, ventura:       "d93ed788971bd7a60d1fdc3fbffe8b1403c85ecb1896fc7fb3ff8855609cea43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd48b5520e5bc1fa97416e456b4c34ab5ed81142bed0c0acc582978647782951"
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
