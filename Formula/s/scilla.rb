class Scilla < Formula
  desc "DNS, subdomain, port, directory enumeration tool"
  homepage "https://edoardottt.com/"
  url "https://github.com/edoardottt/scilla/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "f1a738745a2b45aa1dd37e1754a186bc08fb186f01e241257c7ae5a176eb7d44"
  license "GPL-3.0-or-later"
  head "https://github.com/edoardottt/scilla.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b143f09dc5934d6b3cada68a00d3c74c1698bafb1d0d8656c0968c81bec95cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0b143f09dc5934d6b3cada68a00d3c74c1698bafb1d0d8656c0968c81bec95cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b143f09dc5934d6b3cada68a00d3c74c1698bafb1d0d8656c0968c81bec95cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "0b143f09dc5934d6b3cada68a00d3c74c1698bafb1d0d8656c0968c81bec95cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1ec399d2a8a7b3dac091eaf0b296de3f8d295a4743da1773e8d2bb9b750159a9"
    sha256 cellar: :any,                 x86_64_linux:      "5f6669a27970bf70cb89a4f937a9b08ea5878ee4d8883d65e905425c5c5d2245"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/scilla"
  end

  test do
    output = shell_output("#{bin}/scilla dns -target brew.sh")
    assert_match <<~EOS, output
      =====================================================
      target: brew.sh
      ================ SCANNING DNS =======================
    EOS

    assert_match version.to_s, shell_output("#{bin}/scilla --help 2>&1", 1)
  end
end
