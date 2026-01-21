class RushParallel < Formula
  desc "Cross-platform command-line tool for executing jobs in parallel"
  homepage "https://github.com/shenwei356/rush"
  url "https://github.com/shenwei356/rush/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "d8d04a4fd506a2f369ec8753b339364cd7e58749f794d60cf2cbbb2a5833c8ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a95b45daad014523cc5d24557039ae9e76878624b9ca1db39d0397f1c22f588"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11c38081a63b62ca8b58dd0f46c6e60700f8800aef74845acf226a2ee10e1b08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b29095d93173c2b8236cb62f5b5ac83505de9a7c1d11afc817c5b32927eb5d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b194b7f20e7a5cf8e967490e9ee619611f4d2a56cf281c54bd6c3430e505e62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "307400fb0aaf2b833959f4dbff23ff0b4927da8d638bcc1bf7a8e6c329627561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f6e1ab80fc6a811226669df1b36e299d92c3482c042f816f33286227d1642d2"
  end

  depends_on "go" => :build

  conflicts_with "rush", because: "both install `rush` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rush")
  end

  test do
    assert_equal <<~EOS, pipe_output("#{bin}/rush -k 'echo 0{}'", (1..4).to_a.join("\n"))
      01
      02
      03
      04
    EOS
  end
end
