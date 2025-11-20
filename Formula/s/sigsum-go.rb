class SigsumGo < Formula
  desc "Key transparency toolkit"
  homepage "https://sigsum.org"
  url "https://git.glasklar.is/sigsum/core/sigsum-go/-/archive/v0.12.0/sigsum-go-v0.12.0.tar.bz2"
  sha256 "027d98550f4b68ecfdb0ec83447a161ba973877359b62c444afe3b236e4951d8"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d6457d10500297a0090527b53cc3561cd1433cd525b652100415d89302a5844"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d6457d10500297a0090527b53cc3561cd1433cd525b652100415d89302a5844"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d6457d10500297a0090527b53cc3561cd1433cd525b652100415d89302a5844"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb5dfd3e2ae08485c8e35043e5bbe1e66f21fa2cd9531deb5d2c765602fd3837"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25b27c632dee402d9458ee6cd7c94d4b8f8aaa68650b8944ca2ba83153dbd0d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "363246e09b45a9e49e8d01254a7c08356b3e2fbf9744e90d39ccce730bd1b6c5"
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
