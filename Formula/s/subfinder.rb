class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "431eaa3ac8b63a31105e3031909d07a6da64d43aa70b8bda4058e587f48036ad"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd75bc115d5695fde8217069df5b06277bf654bdfa6061134904093d75453103"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "174541bd4f90a1b0f8cdec609fb88619b58297bdf3343b981775ec16c5a2b36c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "293178dd4c231a517d57288d6d2c4d6a8e64a466be4420bfcaa06f5832730c09"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2428423e1dfa77f8be4f4b4b835416442684d8ba68e6779ca68348a8463fd7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6583f4e0998441dbfe01620af8da862aea08861275217d19f3b1221b9716a462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac5f8f8adbe419f2d8fc3d45edde0b91ee5e02dc70f7710f1c46c0ac0d8c5535"
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
