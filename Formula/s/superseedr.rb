class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v0.9.30.tar.gz"
  sha256 "641dccd58b7851ae0a903cc16f3557ff55f03f35716dd6078d0895d9ad145834"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a47489ae93c1e5f6c1bb5cbe1ae4a2424856d71cb5b1a72a8c51ba0b594247d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "052b24a653cf5a502de00e35be26a418a95c509ec9dd4b9e2e5835476b0f7c1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29811890a62ddc6b8d0063e3386989bffffe6355c35b7f7062d8b45995236045"
    sha256 cellar: :any_skip_relocation, sonoma:        "753af61644a58f58f7bb911989921f988a74d02dae0931ba79ae4ee1cf06015d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25f8b6fb8473117a436e38b37f1171d53bfd09f6ccd3af04455b9ad96cd1c14e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49288aabe6b7228ade19d49d7dbdb62927ab2efee2af1590bc29c29de99dca03"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # superseedr is a TUI application
    assert_match version.to_s, shell_output("#{bin}/superseedr --version")
  end
end
