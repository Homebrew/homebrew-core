class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.13.1.tar.gz"
  sha256 "6cce984c7fb0067b9dc457274139f277e2ff56488811c96a7ae68102184656f9"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b286b575073f1b89f08bec4d1295917ca9f0d020685bdd4b73cb583108212331"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70d9f8fc513bbc7042f792bc66acef60891ada197a6bbee7f261cf4387080ec0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "977fd65599cc3efdf6155e473a457768a4142766bc475f84fcaa29e38aee57c9"
    sha256 cellar: :any_skip_relocation, ventura:        "abe078d7e27efac30e14071a309a936f54ce29c1141e6fc52cc2a1ab14e72169"
    sha256 cellar: :any_skip_relocation, monterey:       "3ec58f0467a71e33f0eaa32e57d2e0694f9342f56c8b44c4250415a57761228d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a02c7009892c5864a089b898ff74f69d9eb12f7b784e6a02254e31534ccdb97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79761b264f9cfa78387a539611b8b3383783246daff323f2f81810776061c4f2"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"starship", "completions")
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
