class Tenere < Formula
  desc "TUI interface for LLMs written in Rust"
  homepage "https://github.com/pythops/tenere"
  url "https://github.com/pythops/tenere/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "865c9b041faf935545dbb9753b33a8ff09bf4bfd8917d25ca93f5dc0c0cac114"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "27ab0ab6d18b6c5e4d0e7edad7c2543d158804ec027a5604158419416b876a60"
    sha256 cellar: :any,                 arm64_sonoma:  "0960f90c6ae608d04793ddb91503109803974b8f3590006655b1d39c411eea59"
    sha256 cellar: :any,                 arm64_ventura: "aa38fea42e6d5ff2a657d1abbea38712522561bb44a236f0bf2021e4538425fb"
    sha256 cellar: :any,                 sonoma:        "34cfde676da9db9d63b7d9e153ec5e8da89da08fc49ac53fc0ee99c6034fa9d4"
    sha256 cellar: :any,                 ventura:       "d928aa81de543a995db52ee06343ea3eeda83027e95e83b392caa9058d40e232"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90d3fdf2c27e17cb7d24eebc464b5ee2e909193feb891cfde67fce4bace506ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "670e6af5f665d27ba5c502aa245ee64175d561c63af071fa7988129c10d25e2f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  uses_from_macos "zlib"

  def install
    # TODO: ENV["LIBGIT2_NO_VENDOR"] = "1"
    libgit2_version = File.read("Cargo.lock")[/name = "libgit2-sys"\nversion = "(.+)\+(.+)"/, 2]
    odie "Unbundled libgit2 as now using #{libgit2_version}!" if Version.new(libgit2_version) >= "1.8"

    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tenere --version")
    assert_match "Can not find the openai api key", shell_output("#{bin}/tenere 2>&1", 1)
  end
end
