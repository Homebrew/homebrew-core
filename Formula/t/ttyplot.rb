class Ttyplot < Formula
  desc "Realtime plotting utility for terminal with data input from stdin"
  homepage "https://github.com/tenox7/ttyplot"
  url "https://github.com/tenox7/ttyplot/archive/refs/tags/1.7.6.tar.gz"
  sha256 "37347a11899c5bfdb5f15fd69766fc5bdfdcb434aa82ae3e9dd10095c3266675"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f4026e1c0ff17eb7e87065fd24c5193802a2c81e0b30d4560ff97a60587814b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc346ee4e508deae88102e5cb7f81eb8cb340fe318e8ec9ec1b2a05b31d6286b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b01edc73231d71085dcacb8c8e43ac08c6392209282712badd8b176657dbc3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "02d135f7f4097dde30662480d68814f38bfd24c89393197975142cac6aae1e36"
    sha256 cellar: :any,                 arm64_linux:   "005d1c4e4f7b569cfc19c52a9beafc0277179bd6703b0bec34acca2f4ee1b4b3"
    sha256 cellar: :any,                 x86_64_linux:  "e7c93424e6610b971474ebd386af9b5797db872a9e9ff110167a8d3e1c885bd4"
  end

  depends_on "pkgconf" => :build
  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "ttyplot"
  end

  test do
    # `ttyplot` writes directly to the TTY, and doesn't stop even when stdin is closed.
    assert_match "unit displayed beside vertical bar", shell_output("#{bin}/ttyplot -h")
  end
end
