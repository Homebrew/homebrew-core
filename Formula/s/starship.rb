class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "2ab61ae3d2e256266191f670a76a35fd06310ada2777efa0f2b6d2602071d13b"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab8783684e5e78aea7aa22d785edacd8729ba4b7ada4a5710653e24e16ee1674"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "659865f4f7e39ed8fbd11d29e1621e3e04de7ff735fede5821b4cfb1a05e8a7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd8c8b592b7c39e750bc74ab658af18c38298efff3a73cdb45d8fde882e89d56"
    sha256 cellar: :any_skip_relocation, sonoma:         "79479c7b6d77612abc87da8f9f3d784ae098e85fe8c8ea470a4fd5dce01c3d1a"
    sha256 cellar: :any_skip_relocation, ventura:        "f4868ea05619682a4de2ee12546fd96dadb11adc2cb78b7ec626ad5bd3540716"
    sha256 cellar: :any_skip_relocation, monterey:       "37780e9e379688a4ed806dcc143cc018deaacdafc129e40d20d53dd870abd754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cdc7b2ab7017eb24c4032905039b6a117d35b4397c85a0d2ff033a42aefee42"
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
