class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://enter-tainer.github.io/typstyle/"
  url "https://github.com/Enter-tainer/typstyle/archive/refs/tags/v0.11.34.tar.gz"
  sha256 "ce0646d161ee87abbc35ef97e83856310e54a12438a6234b152e281b1cec0af8"
  license "Apache-2.0"
  head "https://github.com/Enter-tainer/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0df5a0462b28143ab374fb180b42c54739693dc0461965de00d8fdf76ec5f97e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ec750fe0b8347ca880ac113f39be98bed6895773fdff7525ea7cf5f545286f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d83ca0e34d21bf842e2169ad879b75e726aa629e004818bb66a6506db7bfe5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "778b1a99289aeccd9c104cda38c2119d0a56c40d115e4c9abd11f138a574e838"
    sha256 cellar: :any_skip_relocation, ventura:       "6481329bbecd38588704ec418758609c268130a075759c863cf99c1a03d8a0e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d09a70e884b16b1270ab44153535374538bf297a816aeb0234c550c5dc5dbf79"
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
