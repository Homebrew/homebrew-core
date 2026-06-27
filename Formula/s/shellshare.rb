class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://shellshare.net"
  url "https://github.com/vitorbaptista/shellshare/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "f9fb71aeb313d582ceca4fe37f0bcbaef905a1cc1c95905f952eea18eb1d6a29"
  license "Apache-2.0"
  head "https://github.com/vitorbaptista/shellshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01a29f7737c8b4c7fe4a65841716f6760b84051bec0befe293dedbc80b8e870b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "613dc92dd886f5258355cc5f7e53659f02ba8814f77b66058f80abaf6fdc5d40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfb3ebfaea2246c7762a23e2f340ae2e38c1ea1b6d54b3d49994e1dcbac6ec71"
    sha256 cellar: :any_skip_relocation, sonoma:        "40dec0c69f08c13ebd085658f532a386b83ba8f041b78b29844f2e568ecd24f6"
    sha256 cellar: :any,                 arm64_linux:   "183be5c210d229cc620f690f64b0d13e58d0b2a43dd7b7ef3ee8e7014cd084b2"
    sha256 cellar: :any,                 x86_64_linux:  "501971e10e40f49c5b66c19188d172c4a1c0ac66be2a63624cfe0e7bbf2d5d3d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shellshare --version")

    port = free_port
    pid = spawn(bin/"shellshare", "server", "--port", port.to_s)
    sleep 2
    assert_match "shellshare", shell_output("curl --silent --max-time 5 http://localhost:#{port}")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
