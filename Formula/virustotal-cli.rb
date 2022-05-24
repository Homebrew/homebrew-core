class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.10.2.tar.gz"
  sha256 "09953ce45c2fbf872f70294d5fb58e856c0167ed6a7e1312f770e45bab18356b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49cb3acdc2acfec6d7c5e90ca3b75a15d597725eefb39c3a18485954b4dd3665"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73e67213c77275de6d81483520d6b69010cc499f6229c8d8ccf93938e2adb6f0"
    sha256 cellar: :any_skip_relocation, monterey:       "d9e61d072fb423cd10c79d2f90436d2d5e11a10074e60cef18d687c74c746808"
    sha256 cellar: :any_skip_relocation, big_sur:        "2262044ba922438a95fad57af7207ae438b90cf39c2921b51ef4044836e048a9"
    sha256 cellar: :any_skip_relocation, catalina:       "770c44dbb66c317f2662ca77771140a245b97405ebcac0c4222e64b0f92eaa37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12f7d8dc597833558487984ec3535ba2b453039662c8580553777a78f1c30e85"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", "-ldflags",
            "-X cmd.Version=#{version}",
            "-o", bin/"vt", "./vt/main.go"

    output = Utils.safe_popen_read("#{bin}/vt", "completion", "bash")
    (bash_completion/"vt").write output

    output = Utils.safe_popen_read("#{bin}/vt", "completion", "zsh")
    (zsh_completion/"_vt").write output
  end

  test do
    output = shell_output("#{bin}/vt url #{homepage} 2>&1", 1)
    assert_match "Error: An API key is needed", output
  end
end
