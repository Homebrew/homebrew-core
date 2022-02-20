class Wapm < Formula
  desc "WebAssembly Package Manager (CLI)"
  homepage "https://wapm.io/"
  url "https://github.com/wasmerio/wapm-cli/archive/v0.5.3.tar.gz"
  sha256 "666146148033db92a03dd094cbf84efdfe696361eaf05834d8668503618db618"
  license "MIT"
  head "https://github.com/wasmerio/wapm-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d2a0da93eae0fc240928ff100d81821c7c8062a7dfc7db1f5eaf8974f912a49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b15b30c4cf92cc8bde9c4004590a529a813cac86350ce0ce8d2df290739e818"
    sha256 cellar: :any_skip_relocation, monterey:       "3776330d724e5af2b6b5f7795e556a1b55f73c0f891c496be97999a0389c4037"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6283beb07078b83bb03020e961d385a9d1a7d1cd35dca42476197a1ebc0965d"
    sha256 cellar: :any_skip_relocation, catalina:       "2737b0cc315e8449b22a4ccaeed983c97cbb8c8cc532160ed78e944447cd93f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b1a22db927392ad1fec4df6e7b7e8d66bf3f8cf6c1dd0b7c872d4ddda2ce1e5"
  end

  depends_on "rust" => :build
  depends_on "wasmer" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["WASMER_DIR"] = ".wasmer"
    ENV["WASMER_CACHE_DIR"] = "#{ENV["WASMER_DIR"]}/cache"
    Dir.mkdir ENV["WASMER_DIR"]
    Dir.mkdir ENV["WASMER_CACHE_DIR"]

    system bin/"wapm", "install", "cowsay"

    expected_output = <<~'EOF'
       _____________
      < hello wapm! >
       -------------
              \   ^__^
               \  (oo)\_______
                  (__)\       )\/\
                     ||----w |
                      ||     ||
    EOF
    assert_equal expected_output, shell_output("#{bin}/wapm run cowsay hello wapm!")

    system "#{bin}/wapm", "uninstall", "cowsay"
  end
end
