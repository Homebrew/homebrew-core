class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/refs/tags/1.0.0.tar.gz"
  sha256 "8fab50202ce3a3f8128e94565cb58cdc2cbf5f816fd7b0855d897a379c9cfaf6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51c8c0dd2a1a71900e5daac273038cd32baa8a95b05d0606d5f7c58533344fef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a17e44fe55495d9f0ca0ec43c6aa41d9be56d69db62d674d655ee8acc5f511d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94cab43683d247b0e69b8e4f0d55d6171746d6a3f13629d2a58a14828dcd810d"
    sha256 cellar: :any_skip_relocation, sonoma:         "82518e0802aa20ab83531a3d947d96b4ce61c1ff9bf173d224609b75dddaf7f3"
    sha256 cellar: :any_skip_relocation, ventura:        "80bda0a84dfb631649cdd4c5d292066778d2f1fc5c7d2d76b13323bd485d7c4f"
    sha256 cellar: :any_skip_relocation, monterey:       "90fe0c52129b503c43222e844a491bebb9dd70631e520b8d0c970b4c73a92e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "089aa3d9f6c9d7deb1f49c5d622575b55b48b75a899a36ef56bf1347f3211dff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"vt", ldflags: "-X cmd.Version=#{version}"), "./vt/main.go"

    generate_completions_from_executable(bin/"vt", "completion", base_name: "vt")
  end

  test do
    output = shell_output("#{bin}/vt url #{homepage} 2>&1", 1)
    assert_match "Error: An API key is needed", output
  end
end
