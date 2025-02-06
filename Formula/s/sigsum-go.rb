class SigsumGo < Formula
  desc "Key transparency toolkit"
  homepage "https://sigsum.org"
  url "https://git.glasklar.is/sigsum/core/sigsum-go/-/archive/v0.10.1/sigsum-go-v0.10.1.tar.bz2"
  sha256 "57ac68a61a8ae846fc446a685620293f98f40d11aca3700834cbf8447bf05c1c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96537b5947091ef902a6064914e41baab59b1437ec9a568fe50793dfcd329a35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96537b5947091ef902a6064914e41baab59b1437ec9a568fe50793dfcd329a35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96537b5947091ef902a6064914e41baab59b1437ec9a568fe50793dfcd329a35"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fc8d859e0b1bc751cbb93293736dbe3f8faa03559738224a676c2269f27cadf"
    sha256 cellar: :any_skip_relocation, ventura:       "9fc8d859e0b1bc751cbb93293736dbe3f8faa03559738224a676c2269f27cadf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "363dbc9e425648b90b1c35e17ec477a82542627e4b7341e15ebff37fc50b863b"
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
