class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.9.0.tar.gz"
  sha256 "58d86e921cbe25aa4e913ae3a24ff95c3ab7aad46fe0cc5f0c8d9b4bd38a8929"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "394d3ed4b2da40a96e908b9c35a2ad172a2c25f0c5bdeeabb15d86fa0f18d1bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38d70601ebf9f4f952d58c4f205529ffe336e9fd4c35140d376089d752ece67e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dd1f339a90883bd19a5cfb42bec88090219833925900f0bb6097baa52039bcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cf2e71fa45c6450cb1aaf66333f6d32b788806fb103a00a124c9ecdbb0f9bf5"
    sha256 cellar: :any,                 arm64_linux:   "65ba3dc848e6c5a7ddd8fcb8c605080788466eb855d4a85fd0601f9dc87680ad"
    sha256 cellar: :any,                 x86_64_linux:  "779a44f790059a177b6ce8f4c95ca21be3905d912bfd9699ef9821f1c04fd402"
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
