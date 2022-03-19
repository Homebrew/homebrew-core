class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.10.1.tar.gz"
  sha256 "b9004ebdd7a66eff15d160fe795b7f3c5577af7c316f896e7e05418e89c3792c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8e1c13cf9b8119cf466140b9e28910cfe5b247a2555088c1632487a51ec99cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e2203cad331b5d0609e262caa5659bb0a09a8a753d1204d1ee1c8fb97e7cba1"
    sha256 cellar: :any_skip_relocation, monterey:       "6b871d2319e76731466a7a2a533b3f1720ab2d557aa86716646760d0edaa6348"
    sha256 cellar: :any_skip_relocation, big_sur:        "6537bd97efe55f16465030f4e2bfc6ea0f441bca7a3b4b5774bef657121271d0"
    sha256 cellar: :any_skip_relocation, catalina:       "dfdd51d62b6df0cd1bd1647e5c562d1a676b75d42d19d8f6bead8eada4bacb23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fcbd0b2f05cf94fb0ca3ed38a0f9da6377cb783d361c91a2f209064f101b5b4"
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
