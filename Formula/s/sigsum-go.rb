class SigsumGo < Formula
  desc "Key transparency toolkit"
  homepage "https://sigsum.org"
  url "https://git.glasklar.is/sigsum/core/sigsum-go/-/archive/v1.0.0/sigsum-go-v1.0.0.tar.bz2"
  sha256 "804854f2ca7579e1d7aba49d9579d24d72de9152cadd4fe1cb902aabfa08a888"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f226c3b60127bbc0fedd38392559de3ce2059ed6a91d61c5b4283e5a98f6cf4e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f226c3b60127bbc0fedd38392559de3ce2059ed6a91d61c5b4283e5a98f6cf4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f226c3b60127bbc0fedd38392559de3ce2059ed6a91d61c5b4283e5a98f6cf4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "993bb0c330b98231d7589966535effd30bab9a43ff886063204c8b1e3ed310af"
    sha256 cellar: :any,                 x86_64_linux:      "5ab02af84651e72e7d23db690d70dda5240596a55e19cdcdeecd2ec100e275e2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    %w[
      sigsum-key
      sigsum-monitor
      sigsum-submit
      sigsum-token
      sigsum-verify
      sigsum-witness
    ].each do |cmd|
      system "go", "build", *std_go_args(output: bin/cmd), "./cmd/#{cmd}"
    end
  end

  test do
    system bin/"sigsum-key", "gen", "-o", "key-file"
    pipe_output("#{bin}/sigsum-key sign -k key-file -o signature", (bin/"sigsum-key").read)
    pipe_output("#{bin}/sigsum-key verify -k key-file.pub -s signature", (bin/"sigsum-key").read)
  end
end
