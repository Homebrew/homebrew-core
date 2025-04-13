class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v16.0.3.tar.gz"
  sha256 "97df1c06f9489ce842756fd27c7a309db952bee16001a7a2e7a337d45904731c"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1fca0552ffc2ff4fb6ebabb2202a7c7ae4c3792011008600b020c4a666c52d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16e84414710871b3c3155351f50fd2d9e06344897d49f2faca7713f736271f0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4524024ae57ba17242373a89c913efe94a1fd640bfcd3d5a6f6abdb8c023d63d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1205a2e8c71dbcfa47bb5b004a13e9bfd3b233fd503dd1005d1df1f4fdcd90c9"
    sha256 cellar: :any_skip_relocation, ventura:       "6bf8d9bfe59b9aa9559bf353e5d973244b41a4bf23a45757dbf7138cb4bde8e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2dc8da7e5b1a567b556cc2f80b5fa5f6d2c76331bf9989a856b4d11f318b43b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc04c619d22b13491dc2c90a0fc5fcb9c9894f6c8e2ed6121d7eab89f462c4e3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"topgrade", "--gen-completion")
    (man1/"topgrade.1").write Utils.safe_popen_read(bin/"topgrade", "--gen-manpage")
  end

  test do
    ENV["TOPGRADE_SKIP_BRKC_NOTIFY"] = "true"
    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew_formula")
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}/bin/)?brew upgrade}o, output
    refute_match(/\sSelf update\s/, output)
  end
end
