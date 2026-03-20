class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "7519b9f6722ef768280cc102da13c10e54e068661a85ec9400e78b8639f378c6"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "131a695ba52f36cdbbb2693d6f0d978c7d5d19d9bccfc152179b9fdf181d370c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6dedf3d925b33b743650d35dba5ca96724ab4dc20965f490b648b4a3d418b5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5449fcedb186fd7c89c765c064bce02cb3180a8da4616c9747f5cfcee6707017"
    sha256 cellar: :any_skip_relocation, sonoma:        "68e1299ab6a0b0b0bbcc25fd89289af209a95d636d560e10e9d84d864b8114e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c236e5c31cd3fc49248f17e8f10ed70c0ea2dab4822251b7704185b5abac6bb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "026df80d9996f9b0021b659c22a4b6eb84292f989c7dc3dc68ab2bba49e48338"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/subfinder"
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")

    # upstream issue, https://github.com/projectdiscovery/subfinder/issues/1124
    config_prefix = if OS.mac?
      testpath/"Library/Application Support/subfinder"
    else
      testpath/".config/subfinder"
    end

    assert_path_exists config_prefix/"config.yaml"
    assert_path_exists config_prefix/"provider-config.yaml"

    assert_match version.to_s, shell_output("#{bin}/subfinder -version 2>&1")
  end
end
