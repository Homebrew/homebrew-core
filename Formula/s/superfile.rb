class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https://github.com/MHNightCat/superfile"
  url "https://github.com/MHNightCat/superfile/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "1735a2a7886b670ff392f1331b2af142416691ac86303945feccbc4a1f2c6a43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8355e22bcdd04b127fb4ae8f86ded6c231a07063b4b8105068ef89b58fa9b12b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b6f20af9a85db00868edc9739b9b2427f3303215e11cd73c381fb3fbdf8d489"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b1f2f5500207220dfad995d5cabe2014443f42dcc1209b9bb75c8cfaf103b14"
    sha256 cellar: :any_skip_relocation, sonoma:         "d39bc47a315745d48ebac4474037d0fbf249a8abf2e24da2a24289b339a3736e"
    sha256 cellar: :any_skip_relocation, ventura:        "fbe24bf18fb1b3e2ed4730e9484afd752b651d6691a97e523e6f0e11d181257a"
    sha256 cellar: :any_skip_relocation, monterey:       "1be33e25a014b380d7a65081519136d8edfcb17bfb5701a010b8350e9dd1aaae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a57a06e34c7befc5a02c124e6219091c1247322ca87564f88804295017bb14b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"spf")
  end

  test do
    # superfile is a GUI application
    assert_match version.to_s, shell_output("#{bin}/spf -v")
  end
end
