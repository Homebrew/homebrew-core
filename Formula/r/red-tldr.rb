class RedTldr < Formula
  desc "Used to help red team staff quickly find the commands and key points"
  homepage "https://payloads.online/red-tldr/"
  url "https://github.com/Rvn0xsy/red-tldr/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "823a2faa8f0259c093284a5609c980e2e836cbb31b515454cb5192701418441a"
  license "MIT"
  head "https://github.com/Rvn0xsy/red-tldr.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b899f36c60a21b05cc3e16a051e0db36d90a60882864f149b812204a7e427652"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b899f36c60a21b05cc3e16a051e0db36d90a60882864f149b812204a7e427652"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b899f36c60a21b05cc3e16a051e0db36d90a60882864f149b812204a7e427652"
    sha256 cellar: :any_skip_relocation, sonoma:        "18d4aca22446fbd71994dc3eeca8abd0b492760fd3148d2fa170e1cfbbf4ae82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92cf80e291015b87bdfeb91ac777b62b5d09e8a4ab2e120e23275d149473b52b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6458162f5cf6ce365bb6a4f3688e7867fff6c8af0ab5e31386d9bfbfa4232e4e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"red-tldr", shell_parameter_format: :cobra)
  end

  test do
    assert_match "privilege", shell_output("#{bin}/red-tldr mimikatz")
  end
end
