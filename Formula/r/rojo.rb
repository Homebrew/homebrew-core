class Rojo < Formula
  desc "Professional grade Roblox development tools"
  homepage "https://rojo.space/"
  url "https://github.com/rojo-rbx/rojo/archive/refs/tags/v7.3.0.tar.gz"
  sha256 "849626d5395ccc58de04c4d6072c905880432c58bb2dc71ca27ab7f794b82187"
  license "MPL-2.0"
  head "https://github.com/rojo-rbx/rojo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "236533d0cb6ea8d14cedc69cebd9c6a9e053cffee0f95641b0d58ba6e6c0e4c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81e8d5261e322a2a919295353a763fbd7f1d8a2cf3556aab80e5cfe457d19fe6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fcff3eac2a7045e2b7d214561a9d8063fd4cd449d873e17bfc301a3f484d08e"
    sha256 cellar: :any_skip_relocation, ventura:        "cc6a54ce4f5e8fb0aaed30c88eac4e65b245374aa7ce453deab3e0b1a89479f8"
    sha256 cellar: :any_skip_relocation, monterey:       "636363d45159bfd23981891f3fe10c1154b0c11b6c65dc6000b9ce2eef226796"
    sha256 cellar: :any_skip_relocation, big_sur:        "770681139d18142aa8a684e58fd68d29be7386a625e631f45cee858dae1b8515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3100624c3e30d51adb62aa7806296374faae2d357fee855dcb231a49b80887ff"
  end

  depends_on "rust" => :build
  depends_on "wally" => :build

  def install
    system "wally", "install", "--project-path", "./plugin"
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"rojo", "init"
    assert_predicate testpath/"default.project.json", :exist?

    assert_match version.to_s, shell_output(bin/"rojo --version")
  end
end
