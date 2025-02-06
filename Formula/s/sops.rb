class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/getsops/sops"
  url "https://github.com/getsops/sops/archive/refs/tags/v3.9.4.tar.gz"
  sha256 "3e0fc9a43885e849eba3b099d3440c3147ad0a0cd5dd77a9ef87c266a8488249"
  license "MPL-2.0"
  head "https://github.com/getsops/sops.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47fb0da48816583bb499374230d9a1eb3d568dbfb3e5dad262b2b416f13c71c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47fb0da48816583bb499374230d9a1eb3d568dbfb3e5dad262b2b416f13c71c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47fb0da48816583bb499374230d9a1eb3d568dbfb3e5dad262b2b416f13c71c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6714897154831757549504869480fdd212b3ff6249f547b1c321e8173fa4750"
    sha256 cellar: :any_skip_relocation, ventura:       "b6714897154831757549504869480fdd212b3ff6249f547b1c321e8173fa4750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8787fc174766bbf18e0014ae7b80438e12db9a5db76d0b9645842c867135d10"
  end

  depends_on "go" => :build

  def install
    system "go", "mod", "tidy"

    ldflags = "-s -w -X github.com/getsops/sops/v3/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/sops"
    pkgshare.install "example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version")

    assert_match "Recovery failed because no master key was able to decrypt the file.",
      shell_output("#{bin}/sops #{pkgshare}/example.yaml 2>&1", 128)
  end
end
