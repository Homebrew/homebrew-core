class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs/"
  url "https://github.com/starship/starship/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "e77f3c23683eb544f6dae7171e3c80676aefc66329225bdcd58e40846bb6445f"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcedaba133399c367588a139b85385636852c75d46a9bbfebe027b446e263110"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37d0d5573f8e0da2874815525c108070ef1530b27857e55bdd7e3bb3934020a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d29395988c3d51c12a8ae85c5e21f2be9faf598ceb124fc6d0d059a13faba97a"
    sha256 cellar: :any_skip_relocation, sonoma:        "64ef96430a947d56c89e56bf129716273807023cb4f68d75a7f73e54a9e077cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9867e68fcc811d9a2921d65625b4f833e4860e968139560f6b89f00946e9a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7372da880ca586eba5155e17df047da55e0b3457bfe8f207a90ec66c99a9781c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
    depends_on "zlib-ng-compat"
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
