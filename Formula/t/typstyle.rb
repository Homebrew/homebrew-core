class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://enter-tainer.github.io/typstyle/"
  url "https://github.com/Enter-tainer/typstyle/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "11d19d75d370330ad129bb7b6cd5387ace454451fc3522cf93bda0d8bce2d514"
  license "Apache-2.0"
  head "https://github.com/Enter-tainer/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6937e737bfd60d57292f34fefde09bc9f9ac2f3cd5e9ec5d9b7998d34d7ccaf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e354ea1aad3868355ac43664ec3d3eb93f3e2c236d994d9aa77a38fc3fcdb9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "926c49fbfc4ce378c50bfa9e87f938b5ec7f08b83b44131162e7b703573d30b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8aeb3518d2c94e1c86a9364aa48ed19e48a819d16cfd9cdcdb6fdfcdddf62d7"
    sha256 cellar: :any_skip_relocation, ventura:       "9255047e763545e92446f27c44659f98f0e4819b6beed721923eb18df50ab9b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3aea55765094d634c80be7521759e61220fd11e11a6bc2545a27e039296af021"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}/typstyle --version")
  end
end
