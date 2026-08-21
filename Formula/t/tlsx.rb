class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "c0aeb253d83f1c8ed261a135b19403caf46cee3066882056875a13d5b1a2a75a"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe8706a7a92309607bf967a15a663b5e0ed795ac084e84b3a63df10dff08192a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d7e324c4e58a38447882f76d7dd729118ed1151e682e6722762a71dc4bad00c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef18a0cc9d02aa869def1e1cd034c4dafd1db35dcb35bdadc0c8bf8423b5d667"
    sha256 cellar: :any_skip_relocation, sonoma:        "d659ca4c032cd99459f4c161abf59e8bef7962167393a919a183c0102ee358a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "551ae1a2d4e4b5fa74cb13d7950c9e626c401ccd3c960af6c53a1ff74f6fa96e"
    sha256 cellar: :any,                 x86_64_linux:  "b480f39235c91264abb7626f2c0d986a73718dc18918ca829e54a9a2514476db"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tlsx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tlsx -version 2>&1")
    system bin/"tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
