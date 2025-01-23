class SigsumGo < Formula
  desc "Key transparency toolkit"
  homepage "https://sigsum.org"
  url "https://git.glasklar.is/sigsum/core/sigsum-go/-/archive/v0.9.1/sigsum-go-v0.9.1.tar.bz2"
  sha256 "68f3a66af6727fa1b44d7dd2429748b23b8767547750113318494c58d7b04ae8"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a977129deb4d7146c9a4a5e8cc40cc414b1a05fa755f0c2c83f4e4028275f29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a977129deb4d7146c9a4a5e8cc40cc414b1a05fa755f0c2c83f4e4028275f29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a977129deb4d7146c9a4a5e8cc40cc414b1a05fa755f0c2c83f4e4028275f29"
    sha256 cellar: :any_skip_relocation, sonoma:        "273c62d9c41f9cc2a0398928e08fcde450e00dbe88c319c5389831b9d231f167"
    sha256 cellar: :any_skip_relocation, ventura:       "273c62d9c41f9cc2a0398928e08fcde450e00dbe88c319c5389831b9d231f167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49ca2235c08e62ddc302f3d03a7aae581d400c6694f723265c173333fed62d33"
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
