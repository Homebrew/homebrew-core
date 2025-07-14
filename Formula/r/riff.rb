class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://github.com/walles/riff/archive/refs/tags/3.4.0.tar.gz"
  sha256 "ac1b973ab3dc0386f59c1b92bb509eab762d1524781c5e60e1208cfce70966e4"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d647a33cd23bb815ea8c396552a022cf2423400dfb6cf087fec99f709898e1f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "077abd694738e7faf49794e9b7f79d7261a6083fb40ea5af3741ef330e15d18a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c7a33a566475c022a2b0e5532af9aef9e0580045464fcf06ed59c4af49d094f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd4ef292492873971a5439229c75780ebaf6209ca58e86a49bd02bc0d394d943"
    sha256 cellar: :any_skip_relocation, ventura:       "dde3696ffaebe009b263d4fd6328e8e84b06d1b2533180e671b40285d7e18e93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8095e9aa32446fbca8b4c455e0cc343931dda8be927a83cdaa8802f6d26946f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1716f7b8cf33bd5a9baf12e8c699972abffcc423b5520c91c6a2979b50593670"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end
