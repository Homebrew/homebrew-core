class SigsumGo < Formula
  desc "Key transparency toolkit"
  homepage "https://sigsum.org"
  url "https://git.glasklar.is/sigsum/core/sigsum-go/-/archive/v0.14.1/sigsum-go-v0.14.1.tar.bz2"
  sha256 "a08b173a6450710d39b68b48ec905f8cd6d52a33e04ddcb011fccc2308e8060b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c658d93f76ded4925fa069d5eb829a294af92d1d80e2e5d9e2db50df5d6abaf7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c658d93f76ded4925fa069d5eb829a294af92d1d80e2e5d9e2db50df5d6abaf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c658d93f76ded4925fa069d5eb829a294af92d1d80e2e5d9e2db50df5d6abaf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "aeaa644cc60417fbaec3c1955dabacd2b7a5ee32efe1b3df9511e8eba24762d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76328003a629d38b6bbead901eb68d0944c9d2541b0f3802755d68de82329619"
    sha256 cellar: :any,                 x86_64_linux:  "ffa72b71bf4c5dea5d0f90f0c86434caf009ba0edb409cda54b4ee3ea5eb6a90"
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
