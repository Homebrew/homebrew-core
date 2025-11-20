class Rv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/spinel-coop/rv"
  url "https://github.com/spinel-coop/rv/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "828048689c60ed0d5e4d9a27fcd643821f5f2acf4b782f447f5b0b17904adee1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spinel-coop/rv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b332d8602c328d36bfc6a691ef3b40cc9b3649dc0ecc416c8a4a5be72a62a78a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6de91c9d133f4987d6bb33ac3bf67303bc84ddca8fecb380fa68ada810469e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97d1d1b3b61d6806e25ab3ae3fa4bbd76a69e43a1d2525522a082fc0d2e88bd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9a7d72c62483279230c8cdd8fdc78b5f0f36740bb4f482388f4b3686401c4a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9a4349ecdbcd10f47260655d02bb2f7a2aa1aa47bc3f138f2ef4dfde6b99334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f30dba4bbe6ec7b4dd8f0058b3f42b572e4298b8e6019dc5fd30cfff82c115ce"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on macos: :sonoma

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rv")
    generate_completions_from_executable(bin/"rv", "shell", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")

    assert_match "No Ruby installations found.", shell_output("#{bin}/rv ruby list --installed-only 2>&1")

    system bin/"rv", "ruby", "install", "3.4.5"
    assert_match "Homebrew", shell_output("#{bin}/rv ruby run 3.4.5 -- -e 'puts \"Homebrew\"'")
  end
end
