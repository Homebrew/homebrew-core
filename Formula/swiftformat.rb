class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.51.7.tar.gz"
  sha256 "6b47fd26a54e5cc88da4c5eabb0992af03dc298090a6ce064c29a5b4c3843b8b"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b65a1bdd61b772a8a733e48fb2d64496fc45f2c6487b2fb599db67d89f69f896"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27ac45af15641bd62f387c6c3a1d269df05ce00890d9a51c0e0b2f3dd1c53055"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48512d2915d1b8ea56d72794bf670b989d5426b70ddb689e8fe320cfd72ea346"
    sha256 cellar: :any_skip_relocation, ventura:        "c0970d6deaf8debf3781e57affbd6c2b88f473e7d92e4aceccb571649b1ed85e"
    sha256 cellar: :any_skip_relocation, monterey:       "bacceb4f04ce1d42aa374654c0ee82a7b371b92454ad08cecfbe77ae01163edf"
    sha256 cellar: :any_skip_relocation, big_sur:        "b47a8eab7165c595d3e4228fbb8fa0befe0a546e671b4215f5c97d7ed2e1855c"
    sha256                               x86_64_linux:   "57e9530360d8afb63a50c98e23a692f02fc7ad54223b455e689a9ae4d689aed5"
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
