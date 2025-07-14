class SigsumGo < Formula
  desc "Key transparency toolkit"
  homepage "https://sigsum.org"
  url "https://git.glasklar.is/sigsum/core/sigsum-go/-/archive/v0.11.2/sigsum-go-v0.11.2.tar.bz2"
  sha256 "70f448a4f4957fa2e5ceccbc3218f0fa59d00b9ea39f1541291f7d6bab3929df"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab6ab52d604a1c0b8f27e0bad63db7c0793a4c3aa6dbec75e44cf3c378cc1fd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab6ab52d604a1c0b8f27e0bad63db7c0793a4c3aa6dbec75e44cf3c378cc1fd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab6ab52d604a1c0b8f27e0bad63db7c0793a4c3aa6dbec75e44cf3c378cc1fd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cb45ba2074a1aeef473f1f9cb2dc05442eedcf79f5138fdcae5d7c0510ebb7b"
    sha256 cellar: :any_skip_relocation, ventura:       "8cb45ba2074a1aeef473f1f9cb2dc05442eedcf79f5138fdcae5d7c0510ebb7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1b33b5897a959403b4fe1d9c4e4c9076ba45bda9eb59ffbe25284082a3fefa1"
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
