class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://github.com/cachix/secretspec/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "0d9b4a89be77f54164c95d71ac0e341546f390458574c1f0f419a9cb84e71cd2"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cad2a9f27a803f61b507efa61d908671c3b7c9e6ebdee18547aa2b2988d925fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c41df5d28b47eabfd55a103aeaf8ee04e9628425424a6cc6e8aeadb8eb4ee82c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f82505afbccd4bb21bd85c5662842adb04470f8f8f5800a58a6f59842eb47305"
    sha256 cellar: :any_skip_relocation, sonoma:        "3500370fea6a9ff22254672eba0850ad180770fa44fb61dd84aee4d914e338c4"
    sha256 cellar: :any,                 arm64_linux:   "d4ebbe3c0a8d13fab931608ebb3521716bcc06b1059c0de4d6a30803ec100eb4"
    sha256 cellar: :any,                 x86_64_linux:  "7281c4f8f1daabda66067ad0b22005f389b5e6df3e557fba0c89344400cc1e4e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "secretspec")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secretspec --version")
    system bin/"secretspec", "init"
    assert_path_exists testpath/"secretspec.toml"
  end
end
