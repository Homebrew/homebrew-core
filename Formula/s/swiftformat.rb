class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.52.4.tar.gz"
  sha256 "be48ed575724a25db1196ace465240397a2c1bc0724d1e452b3ae21ce706cae4"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "211b2c1465afea2476d380c4af2999bdd16dd2d9f62d174f797f83af257706f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e590260ea2cc8857e807f044d2c438445c75837154a3e6ae8be5999b239bcf85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb05650b13b66370e72593f46cc764c46abc956c81aed4c627beeb788dde96f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa49d987ffd2f32284fd422f1038f5a17584655be5cbfc3bb3726752fd00a6c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "85a95d6bedc08f25f232b7d5adbaa99662060a2579cc702685343b3ab9c8b87d"
    sha256 cellar: :any_skip_relocation, ventura:        "6686712b546ae867ec07561ced1c215eb5d93a4f54852f3348a66e52f249f644"
    sha256 cellar: :any_skip_relocation, monterey:       "ed379b65cc248b290cf833ce2a088bfb280276de94bedee6b4c56e21bec36a72"
    sha256 cellar: :any_skip_relocation, big_sur:        "492b417360077a31d5c78cfa173526fb8219430e84d01f24f9402ca1d97a63f0"
    sha256                               x86_64_linux:   "c6e703b2b48601787c1cd4f68adfea340e7ab0f4d9e2ddb3d15e6f38a9d50502"
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
