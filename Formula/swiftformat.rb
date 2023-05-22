class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.51.10.tar.gz"
  sha256 "df3207dc490ca459310f5d94f89a5b5289a044c15b5a4833188586bb4cbf6ccc"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd9153d1900b702142f5ec614ce1aa60c6d81c5723ef730633cda666045f4227"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2eb131e54b00a0bbe0314125455ce89747eaccfd472ef47a912a9c3697743389"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5937151917c57ba44639566b00f067be01cf7fbfab8c6406d5277b6192ea7d23"
    sha256 cellar: :any_skip_relocation, ventura:        "6708a400377466b834031509ea37f90e70b2aa8f1067e6f4360d31cb67134a7e"
    sha256 cellar: :any_skip_relocation, monterey:       "7b7d95159ad3938fbf5042aeabe365f80f92776a0b99d73c81da12668bdaa12e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f288e41f451ef8aba863ce7de908d87c46015d8470902b316ad16c76a90c701"
    sha256                               x86_64_linux:   "6b511ce8015d306915f68730d8d0a9bcbf28e44889cbabd882002fb68f429537"
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
