class SigsumGo < Formula
  desc "Key transparency toolkit"
  homepage "https://sigsum.org"
  url "https://git.glasklar.is/sigsum/core/sigsum-go/-/archive/v0.14.0/sigsum-go-v0.14.0.tar.bz2"
  sha256 "be70fb30a76f19bcf7ae8223887c375239426e3212520e8577e2ed708abe1973"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20a4e48e4609e9c78c83dcd16ca748a151ed15490239912ff5013659dff52462"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20a4e48e4609e9c78c83dcd16ca748a151ed15490239912ff5013659dff52462"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20a4e48e4609e9c78c83dcd16ca748a151ed15490239912ff5013659dff52462"
    sha256 cellar: :any_skip_relocation, sonoma:        "f473d19be0693d6a03ff19138f843f93f4d2fdcc249d47984949fa776a074e25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "232269807e1fc5b04a19886da2b183c50f8ffeba85d64df951f34a65a79fc0bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bdd2858cb28d6b06b525a74c10a209061003f71bd49cde615f8a933c5bd1851"
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
