class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https://github.com/yorukot/superfile"
  url "https://github.com/yorukot/superfile/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "3b1060deab226f9d6de8e57abbcfcf80f356332f1b9de1b042aece94d0571c25"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34d26a515756b88da4157ec7552aadb7e4adeb1dcb1d27c7c43569c7ba8c3c46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ed99c2c5afd4c5a631594048fdf6cf85627985f99c17593166d71e5715dec74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6fd6b796e942c0b6631f54b64f4e9a4bc1406d46d7a579ab0df70010ac96ce8"
    sha256 cellar: :any_skip_relocation, sonoma:         "171b6c453896f89bff56a15e4d2a49647471552ba64d4f2bef246715e7616d1d"
    sha256 cellar: :any_skip_relocation, ventura:        "b549b5c0a9ba3ed6cb5d79545c766e90aded3fc3fd0e1c4d5f952c4f9a4a7ea6"
    sha256 cellar: :any_skip_relocation, monterey:       "9e98c0f9a1f79b073ec7cc17f8a89c741a83d5957b256eda07b99ca0b178e5d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "382e0b777f93ce42d8d59996222e0f1bf0e46f046c171f57d355c0b53c51a55d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"spf")
  end

  test do
    # superfile is a GUI application
    assert_match version.to_s, shell_output("#{bin}/spf -v")
  end
end
