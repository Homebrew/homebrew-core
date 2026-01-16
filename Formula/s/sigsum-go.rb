class SigsumGo < Formula
  desc "Key transparency toolkit"
  homepage "https://sigsum.org"
  url "https://git.glasklar.is/sigsum/core/sigsum-go/-/archive/v0.13.1/sigsum-go-v0.13.1.tar.bz2"
  sha256 "0f2526a7be209618bc890ac8e8b31196ba34e12daae8426f997001a233c329cf"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "097f157c9b495ec7b38281b70520baca962448f628340a3fd28d3febc40ca302"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "097f157c9b495ec7b38281b70520baca962448f628340a3fd28d3febc40ca302"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "097f157c9b495ec7b38281b70520baca962448f628340a3fd28d3febc40ca302"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe1b51b67296464c70ca0c3a817148cb5e907c5d8230700c902531e3c2058eab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d5b58ffc777d860f8a9f4b22994e06d3c0b557be5dd1daf6a45658e8310534a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38cf950aee689fe3601179d22462c2b5f45d3052b94dbae6a7e982911d10b029"
  end

  depends_on "go" => :build

  def install
    %w[
      sigsum-key
      sigsum-monitor
      sigsum-submit
      sigsum-token
      sigsum-verify
      sigsum-witness
    ].each do |cmd|
      system "go", "build", *std_go_args(output: bin/cmd, ldflags: "-s -w"), "./cmd/#{cmd}"
    end
  end

  test do
    system bin/"sigsum-key", "gen", "-o", "key-file"
    pipe_output("#{bin}/sigsum-key sign -k key-file -o signature", (bin/"sigsum-key").read)
    pipe_output("#{bin}/sigsum-key verify -k key-file.pub -s signature", (bin/"sigsum-key").read)
  end
end
