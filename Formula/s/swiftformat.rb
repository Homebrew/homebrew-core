class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.57.2.tar.gz"
  sha256 "f74bba467705734db8d1c943c2a26e0f00c6b53d819fd484d1d9e63af7e8067c"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bb7f11c3283503be50deba3307b67b42e08ffe30aab262550d1d8a3f53d35d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4016d79d6de86cf180140e112aacf471aacf24834083aa15bdad89e7c82748c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "738778be95e10a246492c0f65120d5d06d1c4908f5e728fea43387cbc0566883"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba4c4e98ca173e69cb4e6bb5f2a9fceb40df43174682a68380f8ca889b53948c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f283c36e8f6b4c70f4924aad4fa0d7419cf5743fdcc328ff44e5910ddb37e2ec"
    sha256 cellar: :any_skip_relocation, ventura:       "0a00ed4d5d679dc5f0a46770cb455fca7da98c37aadba4d1fa265e44036b447b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d63f9da3ce82fdfc44729c4854b0b51349cc2adc5c4696e12e46e42b222e1bd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "964a0148fa8d2dff245648287151385f8a97622f1664c484d472d0e2513102a5"
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
